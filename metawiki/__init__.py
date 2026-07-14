"""metawiki · BI 指标知识库的运行时代码包。

分层(仿 chatdoc/rag 的 rag/ 包):
  settings.py   全局配置: 路径 / 可插拔后端开关 / logger
  catalog/      领域模型层: 读事实源 YAML → 口径图(指标 / 底层指标 / 表)
  nlp/          检索层: 分词 + Dealer 语义召回(后端可插拔)
  llm/          模型工厂层: Embedding / Rerank provider 注册(本地零依赖兜底)
  serve/        服务层: MCP server, 把口径图 + 检索暴露为 Agent 工具
  utils/        IO 工具: 读 wiki 页 / chunks

约定: 知识库目录(BIRag/knowledge_base)是【纯数据】(catalog 事实源 + 派生 wiki/index);
      metawiki/ 是【纯代码】, 只读数据产品。知识库路径由 settings.KB_ROOT 决定,
      可用环境变量 BIRAG_KB_ROOT 覆盖。
"""

__version__ = "0.1.0"
