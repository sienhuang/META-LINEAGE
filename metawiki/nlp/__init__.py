"""nlp · 检索层 —— 把 RAG 召回封成 Dealer(仿 chatdoc/rag 的 nlp/search.py)。

  tokenizer.py  粗分词(中英混合); 真实环境可换 rag_tokenizer
  search.py     Dealer: 载入 index/chunks.json → metadata 预过滤 + embedding 打分召回
"""

from .search import Dealer

__all__ = ["Dealer"]
