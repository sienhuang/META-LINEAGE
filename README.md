# MetaWIKI · BI 指标知识库的运行时 + MCP 服务

把散在 4 个系统里的指标口径缝成一张图，通过 **MCP** 暴露给 AI Agent。
支持 **Text-to-SQL 问数 · 数据资产发现 · 业务口径问答 · 数仓开发辅助**。

> MetaWIKI 是【实现】仓库，自包含数据 + 代码 + 构建流水线。
> (设计与思路沉淀在 BIRag；数据与 pipeline 逻辑已整合进本仓库。)
> 代码架构参照 `chatdoc/rag`(RAGFlow) 的分层组织。

## 代码与数据解耦(同仓库内)

```
MetaWIKI/
├── knowledge_base/   ← 纯数据                      metawiki/  ← 纯代码(运行时 + 流水线)
│   catalog/  指标·底层指标·表 YAML + generated/      catalog/  载图: loader→models→graph
│   wiki/     自包含 Markdown 知识页(派生)            nlp/      检索: tokenizer + Dealer
│   index/    chunks.json (RAG 检索块)               llm/      Embedding/Rerank 工厂(可插拔)
│   examples/ 黄金 SQL 样例                           pipeline/ 数据构建: p1→build_wiki→build_index
│   chart-index.generated.json (前端扫描原料)        serve/    MCP server + 工具实现
│   DESIGN.md / README.md (设计文档)                  utils/    读 wiki 页等 IO
└── metawiki/                                        settings.py  路径/后端/日志
```

知识库路径由 `metawiki/settings.py` 的 `KB_ROOT` 决定，默认 `MetaWIKI/knowledge_base`，
可用环境变量 `BIRAG_KB_ROOT` 覆盖到别处。

## 数据怎么重建(pipeline)

```bash
python -m metawiki.pipeline.p1_parse_charts   # chart-index → catalog/generated/*.json
python -m metawiki.pipeline.build_wiki        # catalog(口径图) → wiki/*.md
python -m metawiki.pipeline.build_index       # wiki → index/chunks.json
# (python -m metawiki.pipeline.extract_metadata  从库里抽 catalog/tables, 待接数据源)
```

## 分层(对照 chatdoc/rag)

| MetaWIKI | 对应 rag/ | 职责 |
|---|---|---|
| `settings.py` | `settings.py` | 路径、可插拔后端开关、logger 集中配置 |
| `catalog/` | `app/`(领域建模部分) | 读事实源 → 四层口径图(连接/校验/`trace_lineage`) |
| `nlp/` | `nlp/` | 分词 + `Dealer` 召回(metadata 预过滤 + 打分) |
| `llm/` | `llm/` | `EmbeddingModel`/`RerankModel` provider 工厂 |
| `pipeline/` | `svr/task_executor` | 离线构建: chart-index → catalog → wiki → index |
| `serve/` | `svr/` | MCP server，把图 + 检索暴露为 Agent 工具 |
| `utils/` | `utils/` | IO 工具(读 wiki 页) |

## MCP 工具(两类)

| 工具 | 类型 | 用途 |
|---|---|---|
| `get_metric(name)` | 确定性 | 返回指标完整四层口径链(自包含 wiki 页) |
| `get_table(name)` | 确定性 | 返回表字段/含哪些指标/血缘 |
| `trace_lineage(metric)` | 确定性 | 沿四层链回溯，紧凑口径链 |
| `search_kb(query, type_, top_k)` | RAG | 语义召回相关 wiki 页 |
| `search_examples(query, metric, top_k)` | RAG | 语义召回黄金 SQL 样例(few-shot) |

口径问答/写 SQL 走确定性工具(不能模糊)；找表/长尾走 RAG 召回；写 SQL 前用 `search_examples` 取样例 few-shot。

工具层架构参照 `mock-manus`(`domain/services/tools`): `@tool` 声明 OpenAI schema · `BaseTool`
统一 `get_tools()/has_tool()/invoke()`(自动过滤幻觉入参) · `ToolResult` 统一返回。
故同一套 `KnowledgeTools` 既被本仓库 FastMCP server 包装, 也可被 manus 风格 Agent 直接绑定给 LLM 调用。

## 可插拔检索后端

切后端只改 `settings.EMBEDDING_BACKEND`(或环境变量 `BIRAG_EMBEDDING`)，不动 `Dealer`：

- `local`(默认) — 零依赖 token 重合度召回，立刻能跑。
- `baai` / `openai` — 真实 embedding 向量召回(`llm/embedding_model.py` 中为 stub，填 `encode`+余弦即可)。

## 快速开始

```bash
uv pip install pyyaml mcp          # 已装则跳过

# 模拟一次 Agent 问答(无需 MCP 客户端，验证口径链取通)
python -m metawiki.serve.mcp_server --demo

# 起 MCP server(stdio，供 Claude/IDE 等 MCP 客户端接入)
python -m metawiki.serve.mcp_server
```

## 现状与下一步

- ✅ 已跑通：载图(160 指标 / 354 底层指标 / 1 表) · 校验断链 · RAG 召回 · 5 个工具(FastMCP)
  · 工具层对齐 mock-manus(`BaseTool`/`@tool`/`ToolResult`) · 黄金 SQL 样例工具 `search_examples`。
- ⏭️ 待办：① 真实 embedding 后端(`baai`/`openai`) ② 底层指标 D 层 `algo` 补真值(现多为 `[示例]` 草稿)
  ③ 表节点扩充(当前仅 1 张)。
