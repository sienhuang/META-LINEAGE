"""nlp.search · Dealer —— RAG 语义召回(metadata 预过滤 + embedding 打分 + 可选重排)。

仿 chatdoc/rag 的 nlp/search.py 的 Dealer 模式: 把检索逻辑收口到一个类。
检索块来自 index/chunks.json(每个 wiki 页 = 一个带 metadata 的自包含块)。
打分委托给 llm.embedding(后端可插拔): 默认 local token 召回, 换 baai/openai 即真实向量。
"""
from __future__ import annotations

import json
from dataclasses import dataclass

from .. import settings
from ..llm import get_embedding

logger = settings.getLogger("nlp.search")


class Dealer:
    """召回器: 一次载入检索块, 反复 search。"""

    @dataclass
    class Hit:
        id: str
        ref: str
        score: float
        type: str
        text: str

        def preview(self, n: int = 80) -> str:
            return self.text[:n].replace("\n", " ")

    def __init__(self, chunks: list[dict] | None = None, embedding=None):
        self.chunks = chunks if chunks is not None else self._load_chunks()
        self.embedding = embedding or get_embedding()

    @staticmethod
    def _load_chunks() -> list[dict]:
        path = settings.INDEX_DIR / "chunks.json"
        if not path.exists():
            logger.warning("检索块不存在: %s (先跑 pipeline 建 index)", path)
            return []
        return json.loads(path.read_text(encoding="utf-8"))

    def search(self, query: str, type_: str | None = None,
               top_k: int | None = None) -> list["Dealer.Hit"]:
        """metadata 预过滤(type) → embedding 打分 → 取 top_k。"""
        top_k = top_k or settings.RETRIEVAL_TOP_K
        pool = [c for c in self.chunks
                if type_ is None or c.get("meta", {}).get("type") == type_]
        if not pool:
            return []
        scores = self.embedding.similarity(query, [c["text"] for c in pool])
        ranked = sorted(zip(scores, pool), key=lambda x: -x[0])
        hits = [
            self.Hit(id=c["id"], ref=c.get("ref", ""), score=round(s, 2),
                     type=c.get("meta", {}).get("type", ""), text=c["text"])
            for s, c in ranked if s > 0
        ]
        return hits[:top_k]
