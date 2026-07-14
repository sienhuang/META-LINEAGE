"""build_wiki · catalog(四层口径图) → LLM wiki(自包含 Markdown 知识页)。

每个节点(指标/表)渲染成一页, 每页【自包含】——把四层口径链缝进同一页, 用 [[链接]] 互连。
LLM 读一页即可正确推理, 不必跳别处。wiki 永远从 catalog 重渲染, 不手维护 → 不漂移。

D 层(底表字段口径)在渲染时按需深抽取:
  · 跨任务列级血缘链  —— p4_build_lineage.trace_column(宽表.列)
  · 整条链路 SQL 重建 —— lineage.FieldLogicExtractor.candidate_sql(宽表.列)
PG 不可达时自动跳过深层, 仍用 P5 浅层数据离线渲染。

产出: wiki/metrics/<指标>.md(逻辑页) + <指标>__<scope>.md(实例页) · wiki/tables/*.md · README.md
用法: python -m metawiki.pipeline.build_wiki
"""
from __future__ import annotations

from .. import settings
from ..catalog import KnowledgeGraph

WIKI = settings.WIKI_DIR
log = settings.getLogger("pipeline.build_wiki")


def _safe(name: str) -> str:
    """指标名可能含 / 空格 → 文件名安全化。"""
    return name.replace("/", "／").replace("\\", "＼").strip()


def _inst_key(metric: str, inst: dict) -> str:
    """实例页 key: 指标__scope__dataset(同 scope 多 dataset 时不撞名)。"""
    return f"{_safe(metric)}__{inst.get('scope') or '?'}__{inst.get('dataset_id') or 'na'}"


# --------------------------------------------------------------------------- D 层深抽取
class _Enricher:
    """持 FieldLogicExtractor + trace_column, 带缓存; PG 不可达则降级为空。"""

    def __init__(self) -> None:
        self.ok = False
        self._cache: dict[tuple[str, str], dict] = {}
        try:
            from .p4_build_lineage import trace_column
            from .p4_field_logic import candidate_sql
            self._candidate_sql = candidate_sql
            self._trace_column = trace_column
            self.ok = True
        except Exception as exc:  # noqa: BLE001
            log.warning("D 层深抽取不可用(PG?), wiki 只渲染浅层: %s", exc)

    def field(self, wide_table: str, column: str) -> dict:
        """返回 {chain:[...], sql:str|None, incomplete:bool}。失败返回空链。"""
        if not self.ok or not wide_table or not column:
            return {"chain": [], "sql": None, "incomplete": False}
        ckey = (wide_table, column)
        if ckey in self._cache:
            return self._cache[ckey]
        ref = f"{wide_table}.{column}"
        chain, sql, incomplete = [], None, False
        try:
            chain = self._trace_column(ref, depth=8)
        except Exception as exc:  # noqa: BLE001
            log.debug("trace_column 失败 %s: %s", ref, exc)
        try:
            _, _, sql = self._candidate_sql(ref)
            incomplete = _cte_collision(sql)
        except Exception as exc:  # noqa: BLE001
            log.debug("candidate_sql 失败 %s: %s", ref, exc)
        out = {"chain": chain, "sql": sql, "incomplete": incomplete}
        self._cache[ckey] = out
        return out


def _cte_collision(sql: str | None) -> bool:
    """检测重建 SQL 是否有重名 CTE(已知 defect A: 嵌套同名子查询塌缩)。"""
    if not sql:
        return False
    import re
    names = re.findall(r"(?m)^(\w+) AS \($", sql)
    return len(names) != len(set(names))


def _field_logic_block(enr: _Enricher, wide_table: str, column: str, defined_in: str | None) -> list[str]:
    """渲染单个底表字段的 D 层口径(血缘链 + 整条链路 SQL)。"""
    L: list[str] = []
    info = enr.field(wide_table, column)
    chain = info["chain"]
    if chain:
        L.append(f"  - 跨任务血缘链(`{wide_table}.{column}`):")
        for r in chain[:20]:
            expr = (r.get("expression") or "").strip().replace("\n", " ")
            L.append(f"    - d{r['depth']} `{r['target_table']}.{r['target_column']}` "
                     f"⇐ `{r.get('source_table')}.{r.get('source_column')}` "
                     f"[{r.get('lineage_type')}] {('`'+expr[:80]+'`') if expr else ''}")
    elif defined_in:
        L.append(f"  - 口径指针: `{defined_in}`(D 层未自动解析,待补)")
    if info["sql"]:
        warn = "  ⚠️ 重建可能不完整(嵌套同名子查询),以原任务为准\n" if info["incomplete"] else ""
        L.append(f"  - 整条链路 SQL:\n{warn}\n```sql\n{info['sql']}\n```")
    return L


# --------------------------------------------------------------------------- 指标页
def metric_page(m: dict, bases: dict, enr: _Enricher) -> str:
    """逻辑指标页 —— 缝四层链 + D 层字段口径 + 链到各 scope 实例。"""
    L = [f"# {m.get('name_cn')}  `{m['metric']}`\n"]
    L.append(f"**业务口径**: {m.get('hint') or '⚠️ 缺人话口径(待补)'}\n")

    L.append("## 怎么算")
    L.append(f"**公式**: `{m.get('formula') or (m.get('formulas') or ['—'])[-1]}`\n")
    if m.get("base_indicators"):
        L.append("依赖的底层指标:")
        for b in m["base_indicators"]:
            bi = bases.get(b)
            if bi:
                take = f"indicator_map['{b}']" if bi.get("source_type") == "map_key" else b
                L.append(f"- [[{b}]] ({bi.get('name_cn','?')}) — `{bi.get('algo') or '⚠️待D层'}` "
                         f"[{bi.get('status','?')}] · 取数 `{take}`")
            else:
                L.append(f"- [[{b}]] — ⚠️ 未建字典")
        L.append("")

    L.append("## 数据来源")
    wts = m.get("wide_tables") or ([m["wide_table"]] if m.get("wide_table") else [])
    if wts:
        L.append(f"- 宽表: {', '.join(f'[[{w.split(chr(46))[-1]}]]' for w in wts)}")
    else:
        L.append("- 宽表: ⚠️ 待P2")
    L.append(f"- dataset: {m.get('dataset_ids') or m.get('dataset_id') or '—'}  · "
             f"产品线 scope: {m.get('scopes') or '—'}\n")

    # --- D 层: 底表字段生成逻辑 ---
    dlines: list[str] = []
    for b in m.get("base_indicators") or []:
        bi = bases.get(b) or {}
        wt = bi.get("wide_table") or (bi.get("wide_tables") or [None])[0]
        if not wt or bi.get("source_type") == "map_key":
            continue
        blk = _field_logic_block(enr, wt, b, bi.get("defined_in"))
        if blk:
            dlines.append(f"- **{b}** @ `{wt}`")
            dlines.extend(blk)
    if dlines:
        L.append("## 字段生成逻辑(D 层)")
        L.extend(dlines)
        L.append("")

    # --- 实例(各产品线 scope × dataset) ---
    insts = m.get("instances") or []
    if len(insts) > 1:
        L.append("## 各产品线实例")
        for inst in insts:
            L.append(f"- [[{_inst_key(m['metric'], inst)}]] (scope={inst.get('scope')}, "
                     f"dataset={inst.get('dataset_id')}, 宽表={inst.get('wide_table') or '—'})")
        L.append("")

    L.append("## 元信息")
    L.append(f"- 分类: {m.get('category')} · tier: {m.get('tier','长尾')}")
    return "\n".join(L)


def instance_page(metric: dict, inst: dict, bases: dict) -> str:
    """单个产品线 scope 的实例明细页。"""
    sc = inst.get("scope") or "?"
    L = [f"# {metric.get('name_cn')} · {sc}  `{_inst_key(metric['metric'], inst)}`\n"]
    L.append(f"> 逻辑指标 [[{_safe(metric['metric'])}]] 在产品线 **{sc}** 的实例\n")
    L.append(f"- **公式**: `{inst.get('formula') or '—'}`")
    L.append(f"- **业务口径**: {inst.get('hint') or '⚠️ 缺(见逻辑指标)'}")
    L.append(f"- 宽表: {inst.get('wide_table') or '⚠️ 待P2'}  (dataset {inst.get('dataset_id')})")
    L.append(f"- dataset SQL: `{inst.get('dataset_sql_ref') or '—'}`")
    L.append(f"- 维度: {inst.get('dimensions') or '—'}  · 过滤: {inst.get('filters') or '—'}")
    L.append(f"- 来源代码: {inst.get('source_ref') or '—'}")
    return "\n".join(L)


# --------------------------------------------------------------------------- 表页
def table_page(t: dict, metrics: dict, enr: _Enricher) -> str:
    """表知识页 —— 字段 + 底层指标 + 血缘 + D 层生成逻辑。"""
    realtime = (t.get("engine") or "").startswith("flink")
    L = [f"# {t['table']}  ({t.get('name_cn','')})\n", f"> {t.get('description','').strip()}\n"]
    L.append(f"- 物理表: `{t['table']}` · 引擎: {t.get('engine')} · 分层: {t.get('layer')} · "
             f"粒度: {t.get('grain','—')} · 类型: {t.get('kind','—')}\n")
    if realtime and not t.get("columns"):
        L.append("> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。\n")

    cols = t.get("columns") or []
    if cols:
        L.append("## 字段(含直接生成表达式)")
        L.append("| 字段 | 生成方式 | 直接表达式 |")
        L.append("|---|---|---|")
        for c in cols:
            expr = (c.get("expression") or "").strip().replace("\n", " ").replace("|", "\\|")
            L.append(f"| `{c['name']}` | {c.get('lineage_type','—')} | {expr[:120]} |")
        L.append("")

    cbi = t.get("contains_base_indicators", {})
    if cbi.get("in_map") or cbi.get("as_column"):
        L.append("## 包含的底层指标")
        if cbi.get("in_map"):
            L.append(f"- MAP 列里: {', '.join(f'[[{b}]]' for b in cbi['in_map'])}  (取数 `indicator_map['x']`)")
        if cbi.get("as_column"):
            L.append(f"- 直接列: {', '.join(f'[[{b}]]' for b in cbi['as_column'])}  (直接取列)")
        L.append("")

    lin = t.get("lineage", {})
    if lin:
        L.append("## 血缘")
        if lin.get("upstream") is not None:
            L.append(f"- 上游源表: {', '.join(lin.get('upstream') or []) or '—'}")
        if lin.get("feeds_wide_tables"):
            L.append(f"- 流向宽表: {', '.join(f'[[{w.split(chr(46))[-1]}]]' for w in lin['feeds_wide_tables'])}")
        L.append(f"- 由 ETL 构建(task): {', '.join(map(str, lin.get('built_by') or [])) or '—'}")
        used = lin.get("used_by_metrics") or []
        L.append(f"- 被这些指标使用: {', '.join(f'[[{_safe(x)}]]' for x in used[:30]) or '—'}"
                 + (f" …(共 {len(used)})" if len(used) > 30 else ""))
        L.append("")

    if t.get("dataset_set_sql"):
        L.append("## 被 dataset 取数的 SQL(C 层复用口径)")
        L.append(f"```sql\n{t['dataset_set_sql'].strip()[:4000]}\n```")
    return "\n".join(L)


# --------------------------------------------------------------------------- main
def main() -> None:
    g = KnowledgeGraph.load()
    metrics = {k: m.raw for k, m in g.metrics.items()}
    bases = {k: b.raw for k, b in g.bases.items()}
    tables = {k: t.raw for k, t in g.tables.items()}
    enr = _Enricher()

    (WIKI / "metrics").mkdir(parents=True, exist_ok=True)
    (WIKI / "tables").mkdir(parents=True, exist_ok=True)

    n_inst = 0
    for k, m in metrics.items():
        (WIKI / "metrics" / f"{_safe(k)}.md").write_text(metric_page(m, bases, enr), encoding="utf-8")
        for inst in (m.get("instances") or []):
            if not inst.get("scope"):
                continue
            (WIKI / "metrics" / f"{_inst_key(k, inst)}.md").write_text(
                instance_page(m, inst, bases), encoding="utf-8")
            n_inst += 1
    for k, t in tables.items():
        (WIKI / "tables" / f"{_safe(k.split('.')[-1])}.md").write_text(
            table_page(t, metrics, enr), encoding="utf-8")

    idx = ["# LLM Wiki 索引\n",
           f"## 指标 ({len(metrics)} 逻辑 · {n_inst} 实例)"]
    idx += [f"- [[{_safe(k)}]] {m.get('name_cn','')}" for k, m in list(metrics.items())[:10]] + ["- …"]
    idx += [f"\n## 表 ({len(tables)})"] + [f"- [[{_safe(k.split('.')[-1])}]] {t.get('name_cn','')}"
                                          for k, t in list(tables.items())[:30]] + ["- …"]
    (WIKI / "README.md").write_text("\n".join(idx), encoding="utf-8")

    log.info("✓ 逻辑指标页 %d · 实例页 %d · 表页 %d → wiki/  (D 层深抽取: %s)",
             len(metrics), n_inst, len(tables), "开" if enr.ok else "关")
    print(f"✓ 逻辑指标页 {len(metrics)} · 实例页 {n_inst} · 表页 {len(tables)} → wiki/")


if __name__ == "__main__":
    main()
