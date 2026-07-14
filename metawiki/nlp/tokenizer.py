"""nlp.tokenizer · 粗分词(中英混合)。

承接 build_index.tokenize, 复用 LocalTokenEmbed 的分词逻辑作为单一实现,
避免两处分词漂移。真实环境可整体替换为 chatdoc/rag 的 rag_tokenizer。
"""
from __future__ import annotations

from ..llm.embedding_model import LocalTokenEmbed


def tokenize(text: str) -> list[str]:
    return LocalTokenEmbed.tokenize(text)
