"""P4(一) · ETL 任务抽取: leap_metadata.dorado_instance → 每个任务的 SQL 逻辑。

D 层(DESIGN.md §4)最深一层的地基。dorado_instance 是任务【运行实例】(19442 行,
同一 task_id 多次运行); 按 task_id 取最新实例 → 5780 个任务定义。

每行 conf 是 JSON:
    {"typeGroup": "hsql|python|spark|shell|...",
     "configuration": {"operator": {"type": ..., "parameter": {"code": "<代码/SQL>"}}}}
真正的代码/SQL 在 parameter.code(code 列本身是空的)。

本步只负责把 SQL 逻辑【抽出来】(列级血缘解析在 p4_build_lineage):
  · hsql   : code 即 Hive SQL, 用 sqlglot 切成多条语句, 留 DML(INSERT/CREATE/SELECT)
  · python : 用 Python AST 抽 spark.sql("...") 字符串(含 f-string 还原成 {?} 占位)
  其余类型(shell/sensor/dts/notebook)不出 SQL, 只记录不解析。

产出:
  catalog/generated/etl_tasks.json   —— 任务清单(精简: 不含全量 code, 全量在库里)
  metadata_kb.etl_tasks (Postgres)   —— 含 code 原文 + sql_units(jsonb), 整表重灌
用法: python -m metawiki.pipeline.p4_extract_tasks [--no-db]
"""
from __future__ import annotations

import ast
import json
import logging
import re
import sys

import sqlglot
from sqlglot.errors import ErrorLevel

from .. import settings

logging.getLogger("sqlglot").setLevel(logging.ERROR)   # 压掉 Hints/set 的 warning 噪音
log = settings.PARSE_ETL_LOGGER

# typeGroup → sqlglot 方言 / 抽取方式
HSQL_TYPES = {"hsql"}
PYTHON_TYPES = {"python", "pyspark"}

_PG_COLUMNS = [
    "task_id", "instance_id", "name", "queue", "task_type", "dialect",
    "output_hint", "n_sql_units", "sql_units", "parse_status", "code",
]
_PG_JSONB = {"sql_units"}
_PG_DDL = """
CREATE TABLE IF NOT EXISTS {table} (
    task_id       bigint PRIMARY KEY,
    instance_id   bigint,
    name          text,
    queue         text,
    task_type     text,
    dialect       text,
    output_hint   text,
    n_sql_units   integer,
    sql_units     jsonb,
    parse_status  text,
    code          text
)
"""


def conf_to_code(conf: str | None) -> tuple[str | None, str | None]:
    """从 conf JSON 取 (operator.type, parameter.code)。strict=False 容忍裸控制符。"""
    if not conf:
        return None, None
    try:
        j = json.loads(conf, strict=False)
        oper = (j.get("configuration") or {}).get("operator") or {}
        return oper.get("type") or j.get("typeGroup"), (oper.get("parameter") or {}).get("code")
    except (ValueError, TypeError):
        # 兜底: 至少把 type 抠出来(code 里含转义嵌套, 正则抽不可靠 → 留空)
        m = re.search(r'"type"\s*:\s*"([^"]+)"', conf)
        return (m.group(1) if m else None), None


def _is_lineage_stmt(e) -> bool:
    """是否产数据的 DML: INSERT / SELECT / UNION / CTAS / CREATE VIEW AS。

    排除纯建表 DDL(CREATE TABLE(col type...) 无 SELECT)—— 它定义 schema 而非血缘。
    """
    exp = sqlglot.exp
    if isinstance(e, (exp.Insert, exp.Select, exp.Union)):
        return True
    if isinstance(e, exp.Create):
        return e.find(exp.Select) is not None      # 有 SELECT 才是 CTAS/视图, 才有血缘
    return False


def split_hsql(code: str, dialect: str = "hive") -> list[str]:
    """把一段 HSQL 切成多条语句, 只留产出数据的 DML(剔除 set/use/注释/纯建表 DDL)。"""
    try:
        exprs = sqlglot.parse(code, dialect=dialect, error_level=ErrorLevel.IGNORE)
        units = [e.sql(dialect=dialect) for e in exprs if e is not None and _is_lineage_stmt(e)]
        if units:
            return units
    except Exception:
        pass
    # 兜底: 去注释后按 ; 朴素切分; 必须含 select/insert(排除纯建表 DDL)
    cleaned = re.sub(r"--[^\n]*", " ", code)
    cleaned = re.sub(r"/\*.*?\*/", " ", cleaned, flags=re.S)
    out = []
    for s in cleaned.split(";"):
        s = s.strip()
        if re.match(r"(?is)^\s*(insert|select|with|create)\b", s) and \
                re.search(r"(?is)\b(select|insert)\b", s):
            out.append(s)
    return out


def extract_spark_sql(pycode: str) -> list[str]:
    """从 Python 代码抽 spark.sql("...") / x.sql("...") 的 SQL 字符串。

    Constant 直接取; f-string(JoinedStr)把变量段还原成 {?} 占位(保留 SQL 结构)。
    解析不出常量(传变量)的 .sql() 调用跳过。
    """
    try:
        tree = ast.parse(pycode)
    except SyntaxError:
        return []
    out: list[str] = []
    for node in ast.walk(tree):
        if not (isinstance(node, ast.Call) and isinstance(node.func, ast.Attribute)
                and node.func.attr == "sql" and node.args):
            continue
        a = node.args[0]
        if isinstance(a, ast.Constant) and isinstance(a.value, str):
            out.append(a.value)
        elif isinstance(a, ast.JoinedStr):
            parts = []
            for v in a.values:
                parts.append(str(v.value) if isinstance(v, ast.Constant) else "{?}")
            out.append("".join(parts))
    # 必须含 select/insert 才是有血缘的 SQL —— 顺带排除纯建表 DDL(CTAS 含 select 仍保留)
    return [s for s in out if re.search(r"(?is)\b(select|insert)\b", s)]


def _sql_units(task_type: str | None, code: str | None) -> tuple[list[str], str | None]:
    """按任务类型抽 SQL 单元, 返回 (units, dialect)。非 SQL 类型 → ([], None)。"""
    if not code:
        return [], None
    t = (task_type or "").lower()
    if t in HSQL_TYPES:
        return split_hsql(code, "hive"), "hive"
    if t in PYTHON_TYPES:
        return extract_spark_sql(code), "spark"
    return [], None


def fetch_tasks() -> list[dict]:
    """连 MySQL, 按 task_id 取最新实例, 解析每个任务的 SQL 单元。"""
    import pymysql

    schema = settings.MYSQL_DORADO_SCHEMA
    conn = pymysql.connect(
        host=settings.MYSQL_HOST, port=settings.MYSQL_PORT, user=settings.MYSQL_USER,
        password=settings.MYSQL_PASSWORD, database=settings.MYSQL_DB,
        charset="utf8mb4", connect_timeout=15, cursorclass=pymysql.cursors.DictCursor,
    )
    try:
        with conn.cursor() as cur:
            # 每个 task_id 取最新(最大 id)实例 —— 不带文本列, 避开排序内存
            cur.execute(f"SELECT task_id, MAX(id) mid FROM {schema}.dorado_instance "
                        f"GROUP BY task_id")
            latest_ids = [r["mid"] for r in cur.fetchall()]

            tasks: list[dict] = []
            for i in range(0, len(latest_ids), 500):            # 分批取 conf
                batch = latest_ids[i:i + 500]
                ph = ",".join(["%s"] * len(batch))
                with conn.cursor() as c2:
                    c2.execute(
                        f"SELECT id, task_id, queue, name, conf "
                        f"FROM {schema}.dorado_instance WHERE id IN ({ph})", batch)
                    for r in c2.fetchall():
                        ttype, code = conf_to_code(r["conf"])
                        if r["conf"] and ttype is None and code is None:
                            status = "conf_parse_error"
                        elif not code:
                            status = "no_code"
                        else:
                            status = "ok"
                        units, dialect = _sql_units(ttype, code)
                        if status == "ok" and not units and (ttype or "").lower() in (
                                HSQL_TYPES | PYTHON_TYPES):
                            status = "no_sql"
                        tasks.append({
                            "task_id": r["task_id"],
                            "instance_id": r["id"],
                            "name": r["name"],
                            "queue": r["queue"],
                            "task_type": ttype,
                            "dialect": dialect,
                            "output_hint": r["name"],     # 任务名常即产出表(mtai.dm_...)
                            "n_sql_units": len(units),
                            "sql_units": units,
                            "parse_status": status,
                            "code": code,
                        })
            return tasks
    finally:
        conn.close()


def write_to_pg(tasks: list[dict], table: str | None = None) -> int:
    """整表重灌进 metadata_kb.etl_tasks。"""
    import psycopg2
    from psycopg2.extras import Json, execute_values

    table = table or settings.PG_ETL_TASKS_TABLE
    rows = [tuple(Json(t.get(c)) if c in _PG_JSONB else t.get(c) for c in _PG_COLUMNS)
            for t in tasks]
    cols = ", ".join(_PG_COLUMNS)
    with psycopg2.connect(settings.PG_DSN) as conn:
        with conn.cursor() as cur:
            cur.execute(_PG_DDL.format(table=table))
            cur.execute(f"TRUNCATE {table}")
            execute_values(cur, f"INSERT INTO {table} ({cols}) VALUES %s", rows)
        conn.commit()
    return len(rows)


def main(write_db: bool = True) -> None:
    import collections
    tasks = fetch_tasks()

    by_type = collections.Counter(t["task_type"] for t in tasks)
    by_status = collections.Counter(t["parse_status"] for t in tasks)
    sql_tasks = [t for t in tasks if t["sql_units"]]
    total_units = sum(t["n_sql_units"] for t in tasks)

    out = settings.CATALOG_DIR / "generated"
    out.mkdir(parents=True, exist_ok=True)
    # JSON 精简版: 不带全量 code(全量在库); 留 sql_units 方便核对
    slim = [{k: v for k, v in t.items() if k != "code"} for t in tasks]
    (out / "etl_tasks.json").write_text(
        json.dumps(slim, ensure_ascii=False, indent=2), encoding="utf-8")

    log.info("ETL 任务(按 task_id 去重最新): %d", len(tasks))
    log.info("  ├ 按类型: %s", dict(by_type.most_common()))
    log.info("  ├ 出 SQL 的任务: %d  共 %d 条 SQL 单元", len(sql_tasks), total_units)
    log.info("  └ 解析状态: %s", dict(by_status.most_common()))
    log.info("写 catalog/generated/etl_tasks.json: %d 行", len(tasks))

    if write_db:
        try:
            n = write_to_pg(tasks)
            log.info("写入 metadata_kb.%s: %d 行 (整表重灌)", settings.PG_ETL_TASKS_TABLE, n)
        except Exception as exc:
            log.warning("写库失败(%s): %s", type(exc).__name__, exc)
            log.warning("JSON 已落盘; 配好 settings.PG_DSN 后重跑即可。")


if __name__ == "__main__":
    main(write_db="--no-db" not in sys.argv)
