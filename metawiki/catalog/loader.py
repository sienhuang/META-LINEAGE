"""catalog.loader · 读 knowledge_base/catalog 的原始事实(YAML + generated JSON)。

只负责【读盘 → dict】, 不做连接/校验(那是 graph.py 的事)。
精校优先: catalog/metrics/*.yaml(人工) 覆盖 generated/metrics.json(P1 自动产) 的兜底。
"""
from __future__ import annotations

import json

import yaml

from .. import settings


def _read_yaml_dir(dirpath, key_field: str) -> dict[str, dict]:
    """读一个目录下所有 *.yaml, 以 key_field 为主键归并成 dict。"""
    out: dict[str, dict] = {}
    if not dirpath.exists():
        return out
    for f in sorted(dirpath.glob("*.yaml")):
        d = yaml.safe_load(f.read_text(encoding="utf-8"))
        if d and d.get(key_field):
            out[d[key_field]] = d
    return out


def _generated(*names):
    """generated 兜底文件: 优先 P5 缝合产物(*.stitched.json), 无则原始 P1/P2 产物。"""
    gen = settings.CATALOG_DIR / "generated"
    for n in names:
        p = gen / n
        if p.exists():
            return p
    return gen / names[-1]


def load_metrics_raw() -> dict[str, dict]:
    """指标: 人工精校(catalog/metrics) 覆盖兜底(P5 stitched > P1 metrics.json)。"""
    metrics = _read_yaml_dir(settings.CATALOG_DIR / "metrics", "metric")
    gen = _generated("metrics.stitched.json", "metrics.json")
    if gen.exists():
        for m in json.loads(gen.read_text(encoding="utf-8")):
            metrics.setdefault(m["metric"], m)   # setdefault: 不覆盖精校
    return metrics


def load_base_indicators_raw() -> dict[str, dict]:
    """底层指标字典: catalog/base_indicators 覆盖兜底(P5 stitched > P1)。"""
    bases = _read_yaml_dir(settings.CATALOG_DIR / "base_indicators", "key")
    gen = _generated("base_indicators.stitched.json", "base_indicators.json")
    if gen.exists():
        for b in json.loads(gen.read_text(encoding="utf-8")):
            if b.get("key"):
                bases.setdefault(b["key"], b)
    return bases


def load_tables_raw() -> dict[str, dict]:
    """表节点: catalog/tables/*.yaml 覆盖 P5 兜底(generated/tables.json)。"""
    tables = _read_yaml_dir(settings.CATALOG_DIR / "tables", "table")
    gen = settings.CATALOG_DIR / "generated" / "tables.json"
    if gen.exists():
        for t in json.loads(gen.read_text(encoding="utf-8")):
            if t.get("table"):
                tables.setdefault(t["table"], t)
    return tables


def load_examples_raw() -> list[dict]:
    """黄金 SQL 样例: examples/golden_queries.yaml(整文件一个 list)。

    过滤掉模板骨架(id 以 `_` 开头, 如 `_detail_fallback_template`)——
    那是给人看的写法范例, 不该被当真样例召回作 few-shot。
    """
    path = settings.EXAMPLES_DIR / "golden_queries.yaml"
    if not path.exists():
        return []
    data = yaml.safe_load(path.read_text(encoding="utf-8")) or []
    return [e for e in data if e.get("id") and not str(e["id"]).startswith("_")]
