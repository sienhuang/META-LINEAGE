"""build_index · wiki 页 → index/chunks.json(RAG 检索块)。

每页(指标/表)= 一个【自包含】检索块, 带 metadata(type/tier/category/scope/domain),
检索时按业务域/类型【预过滤】再召回, 提升精度; 召回结果就是自包含 wiki 页, 直接喂 LLM。

本脚本只负责【建块】(离线产物); 检索由 metawiki.nlp.Dealer 在服务时做, 二者解耦。
产出: index/chunks.json    用法: python -m metawiki.pipeline.build_index
"""
from __future__ import annotations

import json

from .. import settings
from ..catalog import KnowledgeGraph

WIKI = settings.WIKI_DIR
INDEX = settings.INDEX_DIR


def build_chunks() -> list[dict]:
    """每个 wiki 页 → 一个带 metadata 的检索块。"""
    g = KnowledgeGraph.load()
    chunks: list[dict] = []
    for k, m in g.metrics.items():
        p = WIKI / "metrics" / f"{k}.md"
        if not p.exists():
            continue
        chunks.append({
            "id": f"metric::{k}", "ref": f"wiki/metrics/{k}.md",
            "text": p.read_text(encoding="utf-8"),
            "meta": {"type": "metric", "tier": m.tier,
                     "category": m.category, "scopes": m.scopes},
        })
    for k, t in g.tables.items():
        p = WIKI / "tables" / f"{k}.md"
        if not p.exists():
            continue
        chunks.append({
            "id": f"table::{k}", "ref": f"wiki/tables/{k}.md",
            "text": p.read_text(encoding="utf-8"),
            "meta": {"type": "table", "tier": t.tier,
                     "layer": t.layer, "domain": t.domain},
        })
    return chunks


def main() -> None:
    chunks = build_chunks()
    INDEX.mkdir(parents=True, exist_ok=True)
    (INDEX / "chunks.json").write_text(
        json.dumps(chunks, ensure_ascii=False, indent=2), encoding="utf-8")
    n_metric = sum(1 for c in chunks if c["meta"]["type"] == "metric")
    n_table = sum(1 for c in chunks if c["meta"]["type"] == "table")
    print(f"✓ 入库检索块: {len(chunks)} (指标 {n_metric} + 表 {n_table}) → index/chunks.json")


if __name__ == "__main__":
    main()
