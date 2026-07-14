"""utils.kb_io · 读知识库的派生产物(wiki 自包含页)。

wiki 页是「自包含」的: 每页已缝进四层口径链, LLM 读一页即可作答。
工具层(serve)拿页面直接进 Agent 上下文。
"""
from __future__ import annotations

from .. import settings


def read_wiki_page(kind: str, name: str) -> str:
    """读 wiki/{kind}/{name}.md。kind: metrics | tables。不存在则给出明确提示。"""
    page = settings.WIKI_DIR / kind / f"{name}.md"
    if page.exists():
        return page.read_text(encoding="utf-8")
    label = {"metrics": "指标", "tables": "表"}.get(kind, kind)
    return f"未找到{label}: {name}"
