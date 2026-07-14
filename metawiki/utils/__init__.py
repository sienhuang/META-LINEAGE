"""utils · IO 工具(仿 chatdoc/rag 的 rag/utils, 但这里只读本地知识库文件)。

  kb_io.py  读 wiki 页(自包含 Markdown 知识页)等
"""

from .kb_io import read_wiki_page

__all__ = ["read_wiki_page"]
