"""P4(二) · 列级血缘构建 + 多跳追溯。

承接 p4_extract_tasks: 把每个任务抽出的 SQL 单元喂进 metawiki.lineage 引擎
(sqlglot AST → JobModel), 落成扁平的【物理表.列】级血缘边, 支撑
"一步步追溯某字段的整体计算逻辑"(DESIGN.md §4 D 层)。

血缘边 (column_lineage): target(产出列) <= source(上游列) [direct|derived|aggregated]
  · 物理表(TABLE)端点用真实库表名(如 mt_ads.ads_x.col)→ 可跨任务串联
  · CTE/子查询端点加 job 前缀(cte:<job>:<name>.col)→ 只在任务内有效, 不跨任务误连

跨任务多跳: 任务 A 的产出表 = 任务 B 的源表时, 在 (source==target) 上递归 JOIN 即穿透。

产出:
  catalog/generated/column_lineage.json   —— 全部血缘边
  metadata_kb.column_lineage (Postgres)   —— 同上, 整表重灌 + 建索引(供递归追溯)
用法:
  python -m metawiki.pipeline.p4_build_lineage [--no-db]
  python -m metawiki.pipeline.p4_build_lineage --trace 'mt_ads.ads_x.active_cnt' [--depth 8]       # 列·追上游
  python -m metawiki.pipeline.p4_build_lineage --trace 'mt_dwd.dwd_x.uid' --down [--depth 8]       # 列·追下游
  python -m metawiki.pipeline.p4_build_lineage --trace-table 'mt_ads.ads_x' [--depth 8]            # 表·追上游
  python -m metawiki.pipeline.p4_build_lineage --trace-table 'mt_dwd.dwd_x' --down [--depth 8]     # 表·追下游
"""
from __future__ import annotations

import json
import logging
import sys

from .. import settings
from ..lineage import SqlAstJobModelBuilder

logging.getLogger("sqlglot").setLevel(logging.ERROR)   # 压掉 Hints/set 的 warning 噪音
log = settings.PARSE_ETL_LOGGER

_PG_COLUMNS = [
    "task_id", "job_name", "dialect", "target_table", "target_column", "target_dtype",
    "source_table", "source_column", "source_dtype", "lineage_type", "expression",
]
_PG_DDL = """
CREATE TABLE IF NOT EXISTS {table} (
    id            bigserial PRIMARY KEY,
    task_id       bigint,
    job_name      text,
    dialect       text,
    target_table  text,
    target_column text,
    target_dtype  text,
    source_table  text,
    source_column text,
    source_dtype  text,
    lineage_type  text,
    expression    text
)
"""
_PG_INDEX = [
    "CREATE INDEX IF NOT EXISTS {table}_tgt ON {table} (target_table, target_column)",
    "CREATE INDEX IF NOT EXISTS {table}_src ON {table} (source_table, source_column)",
]


def _dtype(ds) -> str:
    v = ds.dataset_type
    return v.value if hasattr(v, "value") else str(v)


def _endpoint(field, ds_by_id, job_id) -> tuple[str, str, str]:
    """field → (table, column, dtype)。物理表用真名, 临时表(cte/子查询)加 job 前缀。"""
    ds = ds_by_id.get(field.dataset_id)
    if ds is None:
        return "?", field.field_name, "unknown"
    dt = _dtype(ds)
    table = ds.dataset_name if dt == "table" else f"{dt}:{job_id}:{ds.dataset_name}"
    return table, field.field_name, dt


def edges_of_model(model, task_id, dialect) -> list[dict]:
    """一个 JobModel → 列级血缘边(target<=source)。"""
    ds_by_id = {d.dataset_id: d for d in model.datasets}
    f_by_id = {f.field_id: f for f in model.fields}
    expr_by_id = {e.expression_id: e for e in model.field_expressions}
    job_id = model.job.job_id
    out = []
    for ln in model.field_lineage:
        tf = f_by_id.get(ln.target_field_id)
        sf = f_by_id.get(ln.source_field_id)
        if tf is None or sf is None:
            continue
        tt, tc, td = _endpoint(tf, ds_by_id, job_id)
        st, sc, sd = _endpoint(sf, ds_by_id, job_id)
        expr = ""
        if tf.expression_id and tf.expression_id in expr_by_id:
            expr = expr_by_id[tf.expression_id].expression_sql or ""
        lt = ln.lineage_type
        out.append({
            "task_id": task_id, "job_name": model.job.job_name, "dialect": dialect,
            "target_table": tt, "target_column": tc, "target_dtype": td,
            "source_table": st, "source_column": sc, "source_dtype": sd,
            "lineage_type": lt.value if hasattr(lt, "value") else str(lt),
            "expression": expr[:2000],
        })
    return out


def build_edges(tasks: list[dict]) -> tuple[list[dict], dict]:
    """对所有任务的 SQL 单元跑引擎, 汇总血缘边。返回 (edges, stats)。"""
    builders = {"hive": SqlAstJobModelBuilder(dialect="hive"),
                "spark": SqlAstJobModelBuilder(dialect="spark")}
    edges: list[dict] = []
    ok = err = units = 0
    for t in tasks:
        if not t.get("sql_units"):
            continue
        builder = builders.get(t.get("dialect") or "hive", builders["hive"])
        for i, sql in enumerate(t["sql_units"]):
            units += 1
            try:
                model = builder.parse_sql(sql, job_name=f"{t['task_id']}__{i}")
                edges.extend(edges_of_model(model, t["task_id"], t.get("dialect")))
                ok += 1
            except Exception as exc:
                err += 1
                log.debug("解析失败 task_id=%s unit=%d: %s", t["task_id"], i, exc)
    return edges, {"units": units, "parsed_ok": ok, "parse_err": err}


def write_to_pg(edges: list[dict], table: str | None = None) -> int:
    import psycopg2
    from psycopg2.extras import execute_values

    table = table or settings.PG_COLUMN_LINEAGE_TABLE
    rows = [tuple(e.get(c) for c in _PG_COLUMNS) for e in edges]
    cols = ", ".join(_PG_COLUMNS)
    with psycopg2.connect(settings.PG_DSN) as conn:
        with conn.cursor() as cur:
            cur.execute(_PG_DDL.format(table=table))
            cur.execute(f"TRUNCATE {table} RESTART IDENTITY")
            execute_values(cur, f"INSERT INTO {table} ({cols}) VALUES %s", rows)
            for ddl in _PG_INDEX:
                cur.execute(ddl.format(table=table))
        conn.commit()
    return len(rows)


def _collapse_physical(edges: list[dict], direction: str = "up") -> list[dict]:
    """把列级血缘边折叠成【物理表.列 → 物理表.列】:穿过 cte:/subquery:/temp:(名字含 ':')
    临时节点,只在两端都是物理表时落一条边(与 trace_table 同思路,只是带列与表达式)。
    表达式取消费物理列那一跳的(数据来源视角)。"""
    from collections import defaultdict

    adj: dict[tuple, list] = defaultdict(list)
    roots: list[tuple] = []
    rootset: set = set()
    for e in edges:
        tnode = (e["target_table"], e["target_column"])
        snode = (e["source_table"], e["source_column"])
        frm, _to = (tnode, snode) if direction == "up" else (snode, tnode)
        adj[frm].append((snode if direction == "up" else tnode, e))
        if e["depth"] == 0 and frm not in rootset:
            rootset.add(frm); roots.append(frm)

    def is_phys(node: tuple) -> bool:
        return ":" not in node[0]

    def nearest_phys(node: tuple) -> list:
        res, seen = [], set()

        def walk(n):
            for nxt, e in adj.get(n, []):
                if is_phys(nxt):
                    res.append((nxt, e))
                elif nxt not in seen:
                    seen.add(nxt); walk(nxt)

        walk(node)
        return res

    out, emitted, visited = [], set(), set()
    frontier = [(r, 0) for r in roots]
    while frontier:
        node, h = frontier.pop(0)
        if node in visited:
            continue
        visited.add(node)
        for pnode, e in nearest_phys(node):
            if (node, pnode) in emitted:
                continue
            emitted.add((node, pnode))
            t, s = (node, pnode) if direction == "up" else (pnode, node)
            out.append({"depth": h, "target_table": t[0], "target_column": t[1],
                        "source_table": s[0], "source_column": s[1],
                        "lineage_type": e.get("lineage_type"), "expression": e.get("expression"),
                        "task_id": e.get("task_id"), "job_name": e.get("job_name")})
            if pnode not in visited:
                frontier.append((pnode, h + 1))
    return out


def trace_column(ref: str, depth: int = 8, table: str | None = None,
                 direction: str = "up", physical_only: bool = False) -> list[dict]:
    """递归追溯一列的血缘(跨任务多跳)。ref = 'schema.table.column' 或 'table.column'。

    direction='up'   追上游(该列由谁算出, 默认): 锚点匹配 target, 递归 cl.target = tr.source
    direction='down' 追下游(该列流向了谁):       锚点匹配 source, 递归 cl.source = tr.target
    physical_only=True 穿过临时节点, 只返回物理表.列端点(展示用; 解析口径需用完整链)。
    """
    import psycopg2
    from psycopg2.extras import RealDictCursor

    tbl = table or settings.PG_COLUMN_LINEAGE_TABLE
    parts = ref.rsplit(".", 1)
    if len(parts) != 2:
        raise ValueError("ref 形如 'mt_ads.ads_x.active_cnt'(表名.列名)")
    t_table, t_col = parts

    if direction == "up":
        anchor_t, anchor_c = "target_table", "target_column"
        join = "cl.target_table = tr.source_table AND cl.target_column = tr.source_column"
    elif direction == "down":
        anchor_t, anchor_c = "source_table", "source_column"
        join = "cl.source_table = tr.target_table AND cl.source_column = tr.target_column"
    else:
        raise ValueError("direction 只能是 'up'(上游) 或 'down'(下游)")

    sql = f"""
    WITH RECURSIVE trace AS (
        SELECT 0 AS depth, target_table, target_column, source_table, source_column,
               lineage_type, expression, task_id, job_name
        FROM {tbl} WHERE {anchor_t} = %s AND {anchor_c} = %s
        UNION ALL
        SELECT tr.depth + 1, cl.target_table, cl.target_column, cl.source_table,
               cl.source_column, cl.lineage_type, cl.expression, cl.task_id, cl.job_name
        FROM {tbl} cl JOIN trace tr
          ON {join}
        WHERE tr.depth < %s
    )
    SELECT * FROM trace ORDER BY depth
    """
    with psycopg2.connect(settings.PG_DSN) as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, (t_table, t_col, depth))
            edges = [dict(r) for r in cur.fetchall()]
    return _collapse_physical(edges, direction) if physical_only else edges


def trace_table(ref: str, depth: int = 8, table: str | None = None,
                direction: str = "up") -> list[dict]:
    """递归追溯一张表的血缘(跨任务多跳)。ref = 'schema.table' 或 'table'。

    表级血缘 = 在列级 column_lineage 图上做"节点可达性"遍历:
      · 必须穿过临时节点(cte:/subquery:/temp:, 名字含 ':') —— 它们是任务内的中间垫脚石,
        物理上游/下游表常常藏在 CTE 后面, 不穿过就会把链路切断(早期 bug 的根因)
      · 只在【输出】时丢掉临时节点和自身, 仅返回可达的物理表 + 最短跳数
    direction='up'   追上游(该表的数据由哪些表算出, 默认)
    direction='down' 追下游(该表的数据流向了哪些表)
    返回: [{'depth': 最短跳数, 'table': 物理表名}, ...] 按 depth 升序
    """
    import psycopg2
    from psycopg2.extras import RealDictCursor

    tbl = table or settings.PG_COLUMN_LINEAGE_TABLE
    if direction == "up":      # 从 node 出发: target=node 的边, 其 source 是上游 node
        anchor_col, walk_from, walk_to = "target_table", "target_table", "source_table"
    elif direction == "down":  # 从 node 出发: source=node 的边, 其 target 是下游 node
        anchor_col, walk_from, walk_to = "source_table", "source_table", "target_table"
    else:
        raise ValueError("direction 只能是 'up'(上游) 或 'down'(下游)")

    # 先把列级边折叠成"去重的表对"(含临时节点, 只丢自环) —— 否则按表名遍历会在
    # 每列的边上扇出, 219k 行无去重 → 指数爆炸。折叠后图只剩表级节点, 遍历才可控。
    # path 数组做环路守卫: 已在路径上的节点不再展开, 防止 CTE/表互引导致的死循环。
    # depth 只在落到【物理表】时 +1, 穿过临时节点(cte:/subquery:/temp:)不加 —— 这样
    # depth 表示真实的"物理表跳数", 不被 SQL 里 CTE/子查询的嵌套层数撑大。
    sql = f"""
    WITH RECURSIVE edges AS (
        SELECT DISTINCT target_table, source_table
        FROM {tbl} WHERE target_table <> source_table
    ),
    walk AS (
        SELECT CASE WHEN {walk_to} LIKE '%%:%%' THEN 0 ELSE 1 END AS depth,
               {walk_to} AS node, ARRAY[%s::text, {walk_to}] AS path
        FROM edges WHERE {anchor_col} = %s
        UNION ALL
        SELECT w.depth + CASE WHEN e.{walk_to} LIKE '%%:%%' THEN 0 ELSE 1 END,
               e.{walk_to}, w.path || e.{walk_to}
        FROM edges e JOIN walk w ON e.{walk_from} = w.node
        WHERE w.depth < %s AND NOT e.{walk_to} = ANY(w.path)
    )
    SELECT min(depth) AS depth, node AS table
    FROM walk
    WHERE node NOT LIKE '%%:%%' AND node <> %s
    GROUP BY node
    ORDER BY depth, node
    """
    with psycopg2.connect(settings.PG_DSN) as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, (ref, ref, depth, ref))
            return [dict(r) for r in cur.fetchall()]


def _print_trace(ref: str, rows: list[dict], direction: str = "up") -> None:
    label = "计算来源(上游)" if direction == "up" else "流向(下游)"
    if not rows:
        log.info("追溯 %s: 无血缘边(可能该列未被解析到 / 名称不符)", ref)
        return
    log.info("追溯 %s 的%s(共 %d 跳边):", ref, label, len(rows))
    for r in rows:
        pad = "  " * (r["depth"] + 1)
        expr = (r["expression"] or "").replace("\n", " ")[:80]
        log.info("%s[d%d] %s.%s <= %s.%s [%s]%s", pad, r["depth"],
                 r["target_table"], r["target_column"], r["source_table"],
                 r["source_column"], r["lineage_type"], f"  ⟵ {expr}" if expr else "")


def _print_table_trace(ref: str, rows: list[dict], direction: str = "up") -> None:
    label = "上游表" if direction == "up" else "下游表"
    if not rows:
        log.info("追溯表 %s: 无血缘边(可能该表未被解析到 / 名称不符)", ref)
        return
    log.info("追溯表 %s 的%s(共 %d 张物理表):", ref, label, len(rows))
    arrow = "<=" if direction == "up" else "=>"
    for r in rows:
        pad = "  " * (r["depth"] + 1)
        log.info("%s[d%d] %s %s %s", pad, r["depth"], ref, arrow, r["table"])


def main(write_db: bool = True) -> None:
    from . import p4_extract_tasks
    tasks = p4_extract_tasks.fetch_tasks()
    edges, stats = build_edges(tasks)

    out = settings.CATALOG_DIR / "generated"
    out.mkdir(parents=True, exist_ok=True)
    (out / "column_lineage.json").write_text(
        json.dumps(edges, ensure_ascii=False, indent=2), encoding="utf-8")

    log.info("SQL 单元: %d  解析成功: %d  失败: %d", stats["units"], stats["parsed_ok"],
             stats["parse_err"])
    log.info("列级血缘边: %d  → catalog/generated/column_lineage.json", len(edges))

    if write_db:
        try:
            n = write_to_pg(edges)
            log.info("写入 metadata_kb.%s: %d 行 (整表重灌 + 建索引)",
                     settings.PG_COLUMN_LINEAGE_TABLE, n)
        except Exception as exc:
            log.warning("写库失败(%s): %s", type(exc).__name__, exc)


if __name__ == "__main__":
    argv = sys.argv[1:]
    depth = int(argv[argv.index("--depth") + 1]) if "--depth" in argv else 8
    direction = "down" if "--down" in argv else "up"
    if "--trace" in argv:
        ref = argv[argv.index("--trace") + 1]
        phys = "--full" not in argv          # 默认只展示物理表; --full 看完整(含临时节点)链
        _print_trace(ref, trace_column(ref, depth, direction=direction, physical_only=phys), direction)
    elif "--trace-table" in argv:
        ref = argv[argv.index("--trace-table") + 1]
        _print_table_trace(ref, trace_table(ref, depth, direction=direction), direction)
    else:
        main(write_db="--no-db" not in argv)
