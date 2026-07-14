"""P5 · 缝合(stitch): 把四层原料(A 指标 / B 底层指标 / C dataset→宽表 / D 列级血缘)
缝成可建图的派生事实。承接 graph.py docstring 点名的"p5_stitch 缝合逻辑"。

读(原始,不经 loader 以免读到上轮 stitched):
  catalog/generated/{metrics,base_indicators,datasets}.json
  + Postgres column_lineage(D 层列级血缘边)
写(派生,truncate-重写,幂等;不碰 P1/P2/P4 原始产物):
  catalog/generated/metrics.stitched.json       —— 逻辑指标节点(按 metric 合并)+ 各 scope 实例
  catalog/generated/base_indicators.stitched.json —— 回填 wide_table + D 层 algo/defined_in/status
  catalog/generated/tables.json                  —— 表节点(C 宽表 + D 物理源表)

loader 优先读 *.stitched.json,故 P5 输出即图的事实源。
用法: python -m metawiki.pipeline.p5_stitch
连接: settings.PG_DSN / settings.PG_COLUMN_LINEAGE_TABLE(走 .env)。
"""
from __future__ import annotations

import json
import re
from collections import defaultdict

import psycopg2

from .. import settings

_AS_RE = re.compile(r"(?is)^(.*?)\s+AS\s+([A-Za-z_][A-Za-z0-9_]*)$")
_COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)

log = settings.getLogger("pipeline.p5_stitch")

GEN = settings.CATALOG_DIR / "generated"
DIM_SCHEMAS = {"mt_dim", "dim"}


# --------------------------------------------------------------------------- 工具
def _read(name: str) -> list[dict]:
    path = GEN / name
    return json.loads(path.read_text(encoding="utf-8")) if path.exists() else []


def _write(name: str, data) -> None:
    (GEN / name).write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def _split_db(table: str) -> tuple[str | None, str]:
    """schema.table → (db, table); 无前缀则 db=None。"""
    return tuple(table.split(".", 1)) if "." in table else (None, table)


def _infer_layer(table: str) -> str | None:
    name = table.split(".")[-1].lower()
    for p in ("ads", "dws", "dwm", "dwd", "dim", "dm", "ods"):
        if name.startswith(p + "_") or name.startswith(p):
            return p
    return None


def _infer_engine(table: str) -> str:
    return "flink/realtime" if table.startswith("mt_ads_realtime") else "doris/sr"


# --------------------------------------------------------------------------- D 层血缘扫描
def _scan_column_lineage(wide_tables: set[str]) -> tuple[dict, dict]:
    """一次扫 column_lineage(target_table ∈ 宽表全集)。
    返回 (by_tc, by_tt):
      by_tc[(table,col)] = [行...]      —— 给 base 算 algo
      by_tt[table]       = [行...]      —— 给表节点列出列 + 上游
    PG 不可达时返回空(P5 仍可只缝 A/C 层)。
    """
    by_tc: dict[tuple[str, str], list[dict]] = defaultdict(list)
    by_tt: dict[str, list[dict]] = defaultdict(list)
    if not wide_tables:
        return by_tc, by_tt
    try:
        with psycopg2.connect(settings.PG_DSN) as conn, conn.cursor() as cur:
            cur.execute(
                f"""select target_table, target_column, expression, lineage_type,
                           task_id, source_table, source_column
                    from {settings.PG_COLUMN_LINEAGE_TABLE}
                    where target_table = any(%s)""",
                (list(wide_tables),),
            )
            for tt, tc, expr, lt, task, st, sc in cur.fetchall():
                row = {"expression": expr, "lineage_type": lt, "task_id": task,
                       "source_table": st, "source_column": sc}
                by_tc[(tt, tc)].append(row)
                by_tt[tt].append({**row, "target_column": tc})
    except Exception as exc:  # noqa: BLE001  —— 离线兜底
        log.warning("column_lineage 扫描失败(PG 不可达?),D 层留空: %s", exc)
    return by_tc, by_tt


def _norm_algo(e: str) -> str:
    """口径等价归一: 去注释 / 剥外层 COALESCE(x, 默认) / 压空白小写,用于判同。"""
    e = _COMMENT_RE.sub("", e or "").strip()
    m = re.match(r"(?is)^COALESCE\((.*),\s*[^,()]+\)$", e)
    if m:
        e = m.group(1).strip()
    return re.sub(r"\s+", " ", e.lower())


def _decide(exprs: list[str], tasks: list[str], wt: str, key: str) -> dict:
    """据候选表达式裁决 D 层口径状态(等价候选先归一合并)。"""
    exprs = sorted({e.strip() for e in exprs if e and e.strip()})
    tasks = sorted({t for t in tasks if t})
    groups: dict[str, str] = {}                         # 归一签名 → 代表(取最完整的)
    for e in exprs:
        sig = _norm_algo(e)
        if sig and (sig not in groups or len(e) > len(groups[sig])):
            groups[sig] = e
    reps = sorted(groups.values())
    out = {"wide_table": wt,
           "defined_in": f"task://{tasks[0]}@{wt}" if tasks else f"etl://{wt}:{key}",
           "algo_candidates": reps, "etl_tasks": tasks}
    if len(reps) == 1:
        out.update(algo=reps[0], status="已确认")
    elif len(reps) > 1:
        out.update(algo=None, status="草稿")           # 多个真不同口径,不臆选
    else:
        out.update(algo=None, status="待补")
    return out


def _is_map_expr(s: str) -> bool:
    """map 类型表达式(整张 map 的构造/合并/透传),不是标量指标算法。"""
    u = (s or "").upper()
    return "MAP<" in u or "CAST(MAP()" in u or u.startswith(("CAST(MAP", "MAP(", "MAP_CONCAT"))


def _strip_as(expr: str) -> str:
    """去注释 + 去尾部 `AS <别名>`,只留算法主体。"""
    e = _COMMENT_RE.sub("", expr or "").strip()
    m = _AS_RE.match(e)
    return (m.group(1).strip() if m else e)


def _is_trivial(algo: str, key: str) -> bool:
    """非真算法:UNION 分支占位 / 纯透传列(裸列名、t.col、COALESCE(列,默认))。"""
    a = _COMMENT_RE.sub("", algo or "").strip()
    if not a:
        return True
    if "UNION_BRANCH_COLUMN" in a.upper():
        return True
    if _is_map_expr(a):
        return True
    m = re.match(r"(?is)^COALESCE\((.*),\s*[^,()]+\)$", a)   # 剥一层 COALESCE(x, 默认)
    inner = m.group(1).strip() if m else a
    return bool(re.fullmatch(r"[A-Za-z_][A-Za-z0-9_.]*", inner))   # 裸标识符/限定列 = 透传


def _parse_as(expr: str) -> tuple[str | None, str | None]:
    """`<algo> AS <name>` → (name, algo);非定义式(MAP 构造/无 AS)→ (None, None)。"""
    e = _COMMENT_RE.sub("", expr or "").strip()
    m = _AS_RE.match(e)
    if not m:
        return None, None
    algo, name = m.group(1).strip(), m.group(2)
    if name == "indicator_map" or _is_map_expr(algo):
        return None, None
    return name, algo


def _split_args(s: str) -> list[str]:
    """按顶层逗号切参数(尊重括号/引号嵌套)。"""
    args, depth, cur, q = [], 0, "", None
    for ch in s:
        if q:
            cur += ch
            if ch == q:
                q = None
            continue
        if ch in "'\"":
            q = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        elif ch == "," and depth == 0:
            args.append(cur.strip()); cur = ""; continue
        cur += ch
    if cur.strip():
        args.append(cur.strip())
    return args


def _parse_map_literal(expr: str) -> dict[str, str]:
    """从 `MAP('k1', v1, 'k2', v2, …)` 字面量抽出 key → 值表达式(MAP_CONCAT 不算)。"""
    out: dict[str, str] = {}
    low = expr.lower()
    i = 0
    while True:
        j = low.find("map(", i)
        if j < 0:
            break
        prev = expr[j - 1] if j > 0 else " "
        if prev.isalnum() or prev == "_":   # 排除 map_concat / xxx_map(
            i = j + 4
            continue
        depth, k, start = 0, j + 3, j + 3   # k 指向 '('
        while k < len(expr):
            c = expr[k]
            if c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    break
            k += 1
        args = _split_args(expr[start + 1:k])
        for a in range(0, len(args) - 1, 2):
            key = args[a].strip().strip("'\"")
            val = args[a + 1].strip()
            if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", key) and not _is_map_expr(val):
                out[key] = val
        i = k + 1
    return out


def _scan_map_keys(wide_tables: set[str]) -> dict:
    """map_key 专用:追每张宽表的 `indicator_map` 血缘链,抽每个 key 的 `… AS key` 算法。
    返回 mk[(wide_table, key)] = {"exprs": set, "tasks": set}。
    """
    mk: dict[tuple[str, str], dict] = defaultdict(
        lambda: {"exprs": set(), "map_vals": set(), "tasks": set()})
    if not wide_tables:
        return mk
    try:
        from .p4_build_lineage import trace_column
    except Exception as exc:  # noqa: BLE001
        log.warning("trace_column 不可用,map_key 口径留空: %s", exc)
        return mk
    for wt in sorted(wide_tables):
        try:
            chain = trace_column(f"{wt}.indicator_map", depth=10)
        except Exception as exc:  # noqa: BLE001
            log.debug("trace indicator_map 失败 %s: %s", wt, exc)
            continue
        for r in chain:
            expr = r.get("expression") or ""
            task = str(r["task_id"]) if r.get("task_id") else None
            name, algo = _parse_as(expr)              # 强证据: <算法> AS <key>
            if name:
                mk[(wt, name)]["exprs"].add(algo)
                if task:
                    mk[(wt, name)]["tasks"].add(task)
            for k, v in _parse_map_literal(expr).items():   # 弱证据: MAP('k', 值) 绑定
                mk[(wt, k)]["map_vals"].add(v)
                if task:
                    mk[(wt, k)]["tasks"].add(task)
    return mk


def _scan_dataset_sql(datasets: list[dict]) -> dict[str, dict[str, str]]:
    """解析各 dataset 的 set_sql(C 层),抽 select 列表的 `<表达式> AS <别名>`。
    很多底层指标不是宽表物理列,而是在 dataset SQL 里现算的(如数组列 reshape)。
    返回 dsql[dataset_id] = {别名: 表达式}。占位符 ${x}/{{x}} 先替成字面量再解析。
    """
    out: dict[str, dict[str, str]] = {}
    try:
        import sqlglot
        from sqlglot import expressions as exp
    except Exception as exc:  # noqa: BLE001
        log.warning("sqlglot 不可用,跳过 dataset SQL 解析: %s", exc)
        return out
    ok = err = 0
    for d in datasets:
        sql = d.get("set_sql")
        did = d.get("dataset_id")
        if not sql or not did:
            continue
        clean = re.sub(r"\$\{[^}]+\}", "1", sql)
        clean = re.sub(r"\{\{[^}]+\}\}", "1", clean)
        try:
            sel = sqlglot.parse_one(clean, read="hive").find(exp.Select)
            if not sel:
                continue
            m: dict[str, str] = {}
            for e in sel.expressions:
                alias = e.alias_or_name
                if not alias:
                    continue
                body = e.this if isinstance(e, exp.Alias) else e
                m[alias] = body.sql(dialect="hive")
            out[str(did)] = m
            ok += 1
        except Exception as exc:  # noqa: BLE001
            err += 1
            log.debug("dataset SQL 解析失败 %s: %s", did, exc)
    log.info("dataset SQL 解析: 成功 %d / 失败 %d", ok, err)
    return out


def _resolve_key(key: str, is_mapkey: bool, wts: list[str], ds_ids: list[str],
                 by_tc: dict, mk_algos: dict, dsql: dict) -> dict:
    """裁决一个底层指标的口径。只用可靠精确源,不跨 dataset / 不跨列名猜测。
    三个源:① 宽表本跳真实列 ETL ② 本 key 自己 datasetId 的 SQL(C 层)③ indicator_map 构造链。
    顺序按 source_type 区分(只定先后,不跳过):
       map_key:       ① → ③ indicator_map 链(权威) → ② dataset SQL
       direct_column: ① → ② dataset SQL → ③ indicator_map 链
    """
    wt0 = wts[0] if wts else ""

    def from_local():                                  # ① 宽表本跳真实列(剔除占位/透传)
        algos, tasks = set(), set()
        for wt in wts:
            for r in by_tc.get((wt, key), []):
                a = _strip_as(r.get("expression"))
                if not _is_trivial(a, key):
                    algos.add(a)
                if r.get("task_id"):
                    tasks.add(str(r["task_id"]))
        return _layer(_decide(sorted(algos), sorted(tasks), wt0, key), "etl") if algos else None

    def from_dsql():                                   # ② 本 key 自己 dataset 的 SQL
        cs = {dsql.get(str(d), {}).get(key, "").strip() for d in ds_ids}
        cs = {e for e in cs if e and not _is_trivial(e, key)}
        if not cs:
            return None
        c = _decide(sorted(cs), [], wt0, key)
        c["defined_in"] = f"dataset://ba/data_set#{ds_ids[0]}" if ds_ids else c["defined_in"]
        return _layer(c, "dataset_sql")

    def from_chain():                                  # ③ map_key: indicator_map 构造链
        exprs, vals, mtasks = set(), set(), set()
        for wt in wts:
            info = mk_algos.get((wt, key))
            if info:
                exprs |= info["exprs"]; vals |= info["map_vals"]; mtasks |= info["tasks"]
        if exprs:
            return _layer(_decide(sorted(exprs), sorted(mtasks), wt0, key), "etl")
        if vals:
            c = _decide(sorted(vals), sorted(mtasks), wt0, key)
            if c["status"] == "已确认":
                c["status"] = "草稿"                     # MAP 绑定值多为透传,降级
            return _layer(c, "etl")
        return None

    order = [from_local, from_chain, from_dsql] if is_mapkey else [from_local, from_dsql, from_chain]
    for src in order:
        c = src()
        if c:
            return c
    return _layer(_todo(wt0, key), "—")


def _layer(cand: dict, layer: str) -> dict:
    """标注口径来源层: etl(D 层) / dataset_sql(C 层) / —(待补)。"""
    cand["algo_layer"] = layer
    return cand


def _todo(wt: str, key: str, tasks: set | None = None) -> dict:
    t = sorted(tasks or ())
    return {"wide_table": wt or None, "algo": None, "status": "待补",
            "algo_candidates": [], "etl_tasks": t,
            "defined_in": (f"task://{t[0]}@{wt}" if t else (f"etl://{wt}:{key}" if wt else None))}


# --------------------------------------------------------------------------- 缝合
def stitch() -> dict:
    metrics_raw = _read("metrics.json")
    bases_raw = _read("base_indicators.json")
    datasets = _read("datasets.json")

    ds_map = {d["dataset_id"]: d for d in datasets if d.get("dataset_id")}
    wide_tables_all = {d["wide_table"] for d in datasets if d.get("wide_table")}

    by_tc, by_tt = _scan_column_lineage(wide_tables_all)

    # ---- C: 实例挂 wide_table + 反向映射 ----
    wt2metrics: dict[str, set] = defaultdict(set)   # 宽表 → 逻辑指标 key
    wt2bases = defaultdict(lambda: {"in_map": set(), "as_column": set()})

    # ---- A: 按 metric 名合并成逻辑指标 ----
    logical: dict[str, dict] = {}
    for m in metrics_raw:
        key = m["metric"]
        ds_id = m.get("dataset_id")
        wt = ds_map.get(str(ds_id), {}).get("wide_table") if ds_id else None
        inst = {
            "scope": m.get("scope"), "dataset_id": ds_id, "wide_table": wt,
            "formula": m.get("formula"), "hint": m.get("hint"),
            "dimensions": m.get("dimensions"), "filters": m.get("filters"),
            "card_key": m.get("card_key"), "chart_id": m.get("chart_id"),
            "source_ref": m.get("source_ref"),
            "dataset_sql_ref": f"mysql://ba/data_set#{ds_id}" if ds_id else None,
        }
        node = logical.get(key)
        if node is None:
            node = logical[key] = {
                "metric": key, "name_cn": m.get("name_cn") or key,
                "category": m.get("category"),
                "formula": m.get("formula"),          # 代表公式
                "hint": m.get("hint"),                # 代表口径(下方择优补)
                "base_indicators": [], "scopes": [], "dataset_ids": [],
                "wide_tables": [], "instances": [], "_seen": set(),
            }
        # 合并
        for b in m.get("base_indicators") or []:
            if b not in node["base_indicators"]:
                node["base_indicators"].append(b)
        for fld, val in (("scopes", m.get("scope")), ("dataset_ids", ds_id),
                         ("wide_tables", wt)):
            if val and val not in node[fld]:
                node[fld].append(val)
        if not node["hint"] and m.get("hint"):
            node["hint"] = m["hint"]
        sig = (inst["scope"], inst["dataset_id"])      # 同 scope+dataset 的重复卡片去重
        if sig not in node["_seen"]:
            node["_seen"].add(sig)
            node["instances"].append(inst)
        if wt:
            wt2metrics[wt].add(key)

    # 代表 wide_table(单数)+ 清理临时字段
    for node in logical.values():
        node["wide_table"] = node["wide_tables"][0] if node["wide_tables"] else None
        node.pop("_seen", None)

    # ---- B/D: base 按 key 合并(原始按 key×dataset 展开)+ 回填 wide_table + D 层口径 ----
    by_key: dict[str, list[dict]] = defaultdict(list)
    for b in bases_raw:
        by_key[b["key"]].append(b)

    # map_key 不是物理列,口径藏在 indicator_map 构造链里 → 追各宽表 indicator_map(精确)。
    mapkey_wts = {ds_map[str(b["dataset_id"])]["wide_table"]
                  for b in bases_raw if b.get("source_type") == "map_key"
                  and b.get("dataset_id") and ds_map.get(str(b["dataset_id"]), {}).get("wide_table")}
    mk_algos = _scan_map_keys(mapkey_wts)
    dsql = _scan_dataset_sql(datasets)             # C 层: dataset SQL 现算的字段表达式

    bases_out = []
    for key in sorted(by_key):
        entries = by_key[key]
        is_mapkey = any(e.get("source_type") == "map_key" for e in entries)
        wts, ds_ids = [], []
        for b in entries:
            ds_id = b.get("dataset_id")
            wt = ds_map.get(str(ds_id), {}).get("wide_table") if ds_id else None
            if ds_id and ds_id not in ds_ids:
                ds_ids.append(ds_id)
            if wt and wt not in wts:
                wts.append(wt)
            if wt:
                wt2bases[wt]["in_map" if b.get("source_type") == "map_key" else "as_column"].add(key)
        best = _resolve_key(key, is_mapkey, wts, ds_ids, by_tc, mk_algos, dsql)
        rep = dict(entries[0])                        # 保留 source_type/usage_count 等
        rep.update(best)
        rep["wide_tables"] = wts
        rep["dataset_ids"] = ds_ids
        bases_out.append(rep)

    # ---- 表节点: C 宽表 ----
    tables_out: list[dict] = []
    for wt in sorted(wide_tables_all):
        db, tbl = _split_db(wt)
        rows = by_tt.get(wt, [])
        cols: dict[str, dict] = {}
        upstream: set[str] = set()
        tasks: set[str] = set()
        for r in rows:
            c = r["target_column"]
            cols.setdefault(c, {"name": c, "expression": r.get("expression"),
                                "lineage_type": r.get("lineage_type")})
            stbl = r.get("source_table") or ""
            if stbl and ":" not in stbl:            # 只留物理上游(丢 cte:/subquery:)
                upstream.add(stbl)
            if r.get("task_id"):
                tasks.add(r["task_id"])
        cbi = wt2bases.get(wt, {"in_map": set(), "as_column": set()})
        tables_out.append({
            "table": wt, "db": db, "name_cn": "",
            "engine": _infer_engine(wt), "layer": _infer_layer(wt),
            "kind": "wide_table",
            "columns": sorted(cols.values(), key=lambda x: x["name"]),
            "contains_base_indicators": {"in_map": sorted(cbi["in_map"]),
                                          "as_column": sorted(cbi["as_column"])},
            "dataset_set_sql": next((d.get("set_sql") for d in datasets
                                     if d.get("wide_table") == wt and d.get("set_sql")), None),
            "lineage": {
                "upstream": sorted(upstream),
                "built_by": sorted(tasks),
                "used_by_metrics": sorted(wt2metrics.get(wt, set())),
            },
        })

    # ---- 表节点: D 物理源表(数据集 FROM 里出现、但不是宽表的)----
    seen = set(wide_tables_all)
    src_feeds: dict[str, set] = defaultdict(set)
    src_isdim: dict[str, bool] = {}
    for d in datasets:
        wt = d.get("wide_table")
        for t in d.get("tables") or []:
            if t in seen:
                continue
            if wt:
                src_feeds[t].add(wt)
            src_isdim[t] = (t.split(".")[0] in DIM_SCHEMAS) or src_isdim.get(t, False)
    for t in sorted(src_feeds):
        db, tbl = _split_db(t)
        tables_out.append({
            "table": t, "db": db, "name_cn": "",
            "engine": _infer_engine(t), "layer": _infer_layer(t),
            "kind": "dim_table" if src_isdim.get(t) else "source_table",
            "columns": [], "contains_base_indicators": {"in_map": [], "as_column": []},
            "lineage": {"feeds_wide_tables": sorted(src_feeds[t]),
                        "used_by_metrics": sorted(
                            {mk for w in src_feeds[t] for mk in wt2metrics.get(w, set())})},
        })

    # ---- 落盘(排序保证幂等 diff)----
    metrics_out = [logical[k] for k in sorted(logical)]
    for n in metrics_out:
        n["instances"].sort(key=lambda i: i.get("scope") or "")
    bases_out.sort(key=lambda b: b["key"])
    _write("metrics.stitched.json", metrics_out)
    _write("base_indicators.stitched.json", bases_out)
    _write("tables.json", tables_out)

    # ---- 统计 ----
    by_status = defaultdict(int)
    for b in bases_out:
        by_status[b.get("status")] += 1
    stats = {
        "metrics_raw": len(metrics_raw), "metrics_logical": len(metrics_out),
        "metrics_with_wide": sum(1 for n in metrics_out if n["wide_tables"]),
        "bases": len(bases_out), "base_status": dict(by_status),
        "tables": len(tables_out),
        "wide_tables": sum(1 for t in tables_out if t["kind"] == "wide_table"),
    }
    return stats


def main() -> None:
    s = stitch()
    log.info("缝合完成: 原始指标 %d → 逻辑指标 %d(%d 个带宽表)",
             s["metrics_raw"], s["metrics_logical"], s["metrics_with_wide"])
    log.info("底层指标 %d  algo 分布: %s", s["bases"], s["base_status"])
    log.info("表节点 %d(宽表 %d)", s["tables"], s["wide_tables"])
    log.info("→ metrics.stitched.json · base_indicators.stitched.json · tables.json")


if __name__ == "__main__":
    main()
