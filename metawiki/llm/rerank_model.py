"""llm.rerank_model · Rerank provider(可选, 默认不启用)。

召回后可选二次精排。settings.RERANK_BACKEND 为空时检索层跳过重排。
LocalRerank 为恒等占位(原样返回); 接 bge-reranker / cohere 时替换 rerank 实现即可。
"""
from __future__ import annotations


class Base:
    def rerank(self, query: str, candidates: list[dict]) -> list[dict]:
        """对召回候选(含 text/score) 重排, 返回新顺序。"""
        raise NotImplementedError


class LocalRerank(Base):
    """恒等占位: 不改变顺序。接真实 reranker 时在此实现交叉编码打分。"""

    def rerank(self, query: str, candidates: list[dict]) -> list[dict]:
        return candidates
