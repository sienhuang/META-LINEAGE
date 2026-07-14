"""llm · 模型工厂层 —— Embedding / Rerank provider 注册。

仿 chatdoc/rag 的 llm/__init__.py: 用 provider 名 → 类 的工厂字典选实现,
切后端只改 settings.EMBEDDING_BACKEND, 不动检索代码(nlp/search.py 的 Dealer)。

默认 local: 零依赖 token 召回, 立刻能跑。
baai/openai: 真实向量召回(stub, 装好依赖/配好 key 后填实现即可)。
"""
from .embedding_model import BAAIEmbed, LocalTokenEmbed, OpenAIEmbed
from .rerank_model import LocalRerank

# provider 名 → Embedding 实现 (对应 rag/llm 的 EmbeddingModel 字典)
EmbeddingModel = {
    "local": LocalTokenEmbed,
    "baai": BAAIEmbed,
    "openai": OpenAIEmbed,
}

# provider 名 → Rerank 实现
RerankModel = {
    "local": LocalRerank,
}


def get_embedding(backend: str | None = None):
    """按 settings.EMBEDDING_BACKEND(或显式 backend) 取一个 embedding 实例。"""
    from .. import settings
    name = backend or settings.EMBEDDING_BACKEND
    cls = EmbeddingModel.get(name)
    if cls is None:
        raise ValueError(f"未知 embedding 后端: {name}; 可选: {list(EmbeddingModel)}")
    return cls()


__all__ = ["EmbeddingModel", "RerankModel", "get_embedding"]
