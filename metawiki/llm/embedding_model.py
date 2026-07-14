"""llm.embedding_model · Embedding provider 实现(本地兜底 + 真实后端 stub)。

统一接口 Base: 检索层(nlp/search.py 的 Dealer)只依赖这个接口, 不关心后端。
  - similarity(query, texts) -> [float]   给一批候选文本打与 query 的相关分

LocalTokenEmbed 不产生真实向量, 用 token 重合度近似相关性, 零依赖、立刻能跑;
BAAIEmbed / OpenAIEmbed 是接真实 embedding 的占位, 实现 encode 后 similarity 走余弦即可。
"""
from __future__ import annotations

import re


class Base:
    """Embedding 接口。检索层只依赖这两个方法。"""

    def encode(self, texts: list[str]) -> list:
        """文本 → 向量。本地兜底无真实向量, 返回 None。"""
        raise NotImplementedError

    def similarity(self, query: str, texts: list[str]) -> list[float]:
        """query 与每个候选文本的相关分。Dealer 用它排序。"""
        raise NotImplementedError


class LocalTokenEmbed(Base):
    """零依赖本地后端: token 重合度近似相关性(承接 build_index.tokenize/score)。"""

    @staticmethod
    def tokenize(text: str) -> list[str]:
        """粗分词: ASCII 词/数字 + 中文单字 + 中文 bigram。够演示。"""
        text = text.lower()
        toks = re.findall(r"[a-z0-9_]+", text)
        cjk = re.findall(r"[一-鿿]", text)
        toks += cjk
        toks += [cjk[i] + cjk[i + 1] for i in range(len(cjk) - 1)]
        return toks

    def encode(self, texts: list[str]):
        return [None] * len(texts)   # 本地后端无真实向量

    def similarity(self, query: str, texts: list[str]) -> list[float]:
        qt = set(self.tokenize(query))
        scores = []
        for t in texts:
            ct = self.tokenize(t)
            cset = set(ct)
            # >>> 换真实后端时: score = cosine(encode([query]), encode([t]))  <<<
            s = sum(1 for w in qt if w in cset) + 0.1 * sum(ct.count(w) for w in qt)
            scores.append(round(s, 2))
        return scores


class BAAIEmbed(Base):
    """真实向量后端(BAAI/bge) 占位。装好 sentence-transformers / FlagEmbedding 后填实现。"""

    def __init__(self, model: str = "BAAI/bge-large-zh-v1.5"):
        self.model = model
        raise NotImplementedError(
            "BAAIEmbed 待实现: 加载 bge 模型, encode 返回归一化向量, similarity 走余弦。"
        )


class OpenAIEmbed(Base):
    """OpenAI / 兼容 API 后端占位。配好 base_url + api_key 后填实现。"""

    def __init__(self, model: str = "text-embedding-3-small"):
        self.model = model
        raise NotImplementedError(
            "OpenAIEmbed 待实现: 调 embeddings API, encode 返回向量, similarity 走余弦。"
        )
