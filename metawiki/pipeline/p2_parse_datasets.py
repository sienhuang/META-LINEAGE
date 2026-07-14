"""P2 · C 层接入: 从 MySQL ba.data_set 拉数据集 SQL → 解析占位符/变量 + 宽表血缘。

承接 P1(A 层指标已带 dataSetId)。本步把 datasetId 对应的 dataset SQL 捞下来,
解析三样东西, 挂回指标的 dataSetId 上(见 DESIGN.md §4 C 层 / §7 取数策略):

  ① 占位符: SQL 里的 ${xxx}(也兼容 {{xxx}}) —— 运行时由前端/Java 填值。
     与 data_set.sql_variable_details(JSON) 按 variableName 匹配, 记录绑定方式。
  ② 宽表血缘: 解析 FROM/JOIN 得到物理表; mt_dim.* 视作维表, 其余为事实/宽表。
     primary fact 即 wide_table(C 层物理载体), Text-to-SQL 复用 dataset SQL 时要它。
  ③ 原文留底: set_sql 原样存下 —— §7 "走宽表 = 包住 dataset SQL 别重写" 的依据。

数据源: settings.MYSQL_* 指向的 ba 库(只用 ba, 不要 ba_cn)。
产出:
  catalog/generated/datasets.json   —— 每个 datasetId 一行(SQL/变量/占位符/宽表)
  metadata_kb.datasets (Postgres)   —— 同一批整表重灌进库(列见 _PG_COLUMNS)
用法: python -m metawiki.pipeline.p2_parse_datasets          # 写 JSON + 库
      python -m metawiki.pipeline.p2_parse_datasets --no-db   # 只写 JSON
连接: settings.PG_DSN / settings.MYSQL_*(均可用 .env 覆盖)。
"""
from __future__ import annotations

import json
import re
import sys

from .. import settings

log = settings.PARSE_DATASET_LOGGER        # 落 logs/parse_dataset_sql.log + 控制台

# JOIN 进来当维度用的 schema, 不算事实宽表
DIM_SCHEMAS = {"mt_dim", "dim"}

# Postgres 落库的列(列名 ←→ dataset dict 的 key); list/dict 走 jsonb。
_PG_COLUMNS = [
    "dataset_id", "ds_schema", "set_name", "set_type", "set_sql", "wide_table",
    "fact_tables", "dim_tables", "tables", "placeholders", "variables",
    "unmatched_placeholders", "unused_variables", "used_by_metrics",
]
_PG_JSONB = {"fact_tables", "dim_tables", "tables", "placeholders", "variables",
             "unmatched_placeholders", "unused_variables"}
_PG_DDL = """
CREATE TABLE IF NOT EXISTS {table} (
    dataset_id             text PRIMARY KEY,
    ds_schema              text,
    set_name               text,
    set_type               text,
    set_sql                text,
    wide_table             text,
    fact_tables            jsonb,
    dim_tables             jsonb,
    tables                 jsonb,
    placeholders           jsonb,
    variables              jsonb,
    unmatched_placeholders jsonb,
    unused_variables       jsonb,
    used_by_metrics        integer
)
"""


def placeholders_of(sql: str | None) -> list[str]:
    """抽 SQL 里的占位符名: ${xxx} 与 {{xxx}} 两种形态, 去重保序。"""
    if not sql:
        return []
    out: list[str] = []
    for pat in (r"\$\{\s*([^}]+?)\s*\}", r"\{\{\s*([^}]+?)\s*\}\}"):
        for n in re.findall(pat, sql):
            n = n.strip()
            if n and n not in out:
                out.append(n)
    return out


def tables_of_sql(sql: str | None) -> tuple[list[str], list[str]]:
    """解析 FROM/JOIN 的 schema.table → (事实表, 维表), 各自去重保序。

    只认带库名的 `schema.table`; `from ( 子查询 )` 自然跳过(其后无 schema.table)。
    """
    if not sql:
        return [], []
    s = re.sub(r"--[^\n]*", " ", sql)                 # 去行注释
    s = re.sub(r"/\*.*?\*/", " ", s, flags=re.S)      # 去块注释
    refs: list[str] = []
    for t in re.findall(r"\b(?:from|join)\s+([A-Za-z_]\w*\.[A-Za-z_]\w*)", s, re.I):
        if t not in refs:
            refs.append(t)
    fact = [t for t in refs if t.split(".")[0].lower() not in DIM_SCHEMAS]
    dim = [t for t in refs if t.split(".")[0].lower() in DIM_SCHEMAS]
    return fact, dim


def _coerce_json(v):
    """sql_variable_details 列: pymysql 可能给 str 也可能已解析; 统一成 Python 对象。"""
    if isinstance(v, str):
        try:
            return json.loads(v)
        except (ValueError, TypeError):
            return None
    return v


def variables_of(detail) -> list[dict]:
    """规整 sql_variable_details → [{variableName, valueBind, operator, values}]。"""
    detail = _coerce_json(detail)
    if not isinstance(detail, list):
        return []
    out = []
    for d in detail:
        if isinstance(d, dict):
            out.append({
                "variableName": d.get("variableName"),
                "valueBind": d.get("valueBind"),
                "operator": d.get("operator"),
                "values": d.get("values"),
            })
    return out


def fetch_datasets() -> list[dict]:
    """连 MySQL ba 库, 读 data_set, 解析成 dataset 行(不落库)。"""
    import pymysql

    schema = settings.MYSQL_DATASET_SCHEMA
    conn = pymysql.connect(
        host=settings.MYSQL_HOST, port=settings.MYSQL_PORT, user=settings.MYSQL_USER,
        password=settings.MYSQL_PASSWORD, database=settings.MYSQL_DB,
        charset="utf8mb4", connect_timeout=10,
        cursorclass=pymysql.cursors.DictCursor,
    )
    try:
        with conn.cursor() as cur:
            cur.execute(
                f"SELECT id, set_name, set_type, set_sql, sql_variable_details "
                f"FROM {schema}.data_set"
            )
            raw = cur.fetchall()
    finally:
        conn.close()

    datasets = []
    for r in raw:
        sql = r.get("set_sql")
        phs = placeholders_of(sql)
        variables = variables_of(r.get("sql_variable_details"))
        declared = {v["variableName"] for v in variables if v["variableName"]}
        fact, dim = tables_of_sql(sql)
        datasets.append({
            "dataset_id": str(r["id"]),
            "ds_schema": schema,
            "set_name": r.get("set_name"),
            "set_type": r.get("set_type"),
            "set_sql": sql,
            "wide_table": fact[0] if fact else None,     # 主事实表 = C 层宽表
            "fact_tables": fact,
            "dim_tables": dim,
            "tables": fact + dim,
            "placeholders": phs,                          # SQL 里的 ${} 名
            "variables": variables,                       # sql_variable_details 原义
            "unmatched_placeholders": [p for p in phs if p not in declared],  # 用了没声明
            "unused_variables": [v["variableName"] for v in variables          # 声明了没用
                                 if v["variableName"] and v["variableName"] not in phs],
        })
    return datasets


def write_to_pg(datasets: list[dict], table: str | None = None) -> int:
    """整表重灌进 metadata_kb.datasets(建表 → TRUNCATE → 批量插)。"""
    import psycopg2
    from psycopg2.extras import Json, execute_values

    table = table or settings.PG_DATASETS_TABLE
    rows = [
        tuple(Json(d.get(c)) if c in _PG_JSONB else d.get(c) for c in _PG_COLUMNS)
        for d in datasets
    ]
    cols = ", ".join(_PG_COLUMNS)
    with psycopg2.connect(settings.PG_DSN) as conn:
        with conn.cursor() as cur:
            cur.execute(_PG_DDL.format(table=table))
            cur.execute(f"TRUNCATE {table}")
            execute_values(cur, f"INSERT INTO {table} ({cols}) VALUES %s", rows)
        conn.commit()
    return len(rows)


def _metric_dataset_ids() -> set[str]:
    """从 P1 产物读出指标用到的 dataSetId, 用来算覆盖率。"""
    gen = settings.CATALOG_DIR / "generated" / "metrics.json"
    if not gen.exists():
        return set()
    return {str(m["dataset_id"]) for m in json.loads(gen.read_text(encoding="utf-8"))
            if m.get("dataset_id")}


def main(write_db: bool = True) -> None:
    datasets = fetch_datasets()

    # 覆盖率: 指标引用的 dataSetId 有多少在 ba 里捞到了
    metric_ids = _metric_dataset_ids()
    have = {d["dataset_id"] for d in datasets}
    hit = metric_ids & have
    miss = sorted(metric_ids - have)
    for d in datasets:
        d["used_by_metrics"] = 1 if d["dataset_id"] in metric_ids else 0

    out = settings.CATALOG_DIR / "generated"
    out.mkdir(parents=True, exist_ok=True)
    (out / "datasets.json").write_text(
        json.dumps(datasets, ensure_ascii=False, indent=2), encoding="utf-8")

    with_sql = sum(1 for d in datasets if d["set_sql"])
    with_wide = sum(1 for d in datasets if d["wide_table"])
    unmatched = sum(1 for d in datasets if d["unmatched_placeholders"])
    log.info("数据集(ba.data_set): %d  (有 SQL: %d, 解析出宽表: %d)",
             len(datasets), with_sql, with_wide)
    log.info("  ├ 指标 dataSetId 覆盖: %d/%d 命中  (缺失 %d 个%s)",
             len(hit), len(metric_ids), len(miss),
             ": " + ", ".join(miss[:10]) + ("…" if len(miss) > 10 else "") if miss else "")
    log.info("  └ 占位符有未声明变量的数据集: %d", unmatched)
    log.info("写 catalog/generated/datasets.json: %d 行", len(datasets))

    if write_db:
        try:
            n = write_to_pg(datasets)
            log.info("写入 metadata_kb.%s: %d 行 (整表重灌)", settings.PG_DATASETS_TABLE, n)
        except Exception as exc:                     # 连不上/缺驱动: 不阻断 JSON 产出
            log.warning("写库失败(%s): %s", type(exc).__name__, exc)
            log.warning("JSON 已落盘; 配好 settings.PG_DSN 后重跑即可。")


if __name__ == "__main__":
    main(write_db="--no-db" not in sys.argv)
