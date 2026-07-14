"""catalog · 领域模型层 —— 知识库的事实源加载与口径图。

职责: 把 knowledge_base/catalog 里的 YAML/JSON 事实(指标 / 底层指标 / 表)
载入为带类型的实体, 缝成可走通、可校验、可回溯的【四层口径图】。

  models.py   Metric / BaseIndicator / Table 数据类(四层口径 schema)
  loader.py   读 catalog/*.yaml + generated/*.json → 原始 dict
  graph.py    KnowledgeGraph: 连接 / 校验断链 / trace_lineage 四层回溯
"""

from .graph import KnowledgeGraph

__all__ = ["KnowledgeGraph"]
