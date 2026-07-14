# BI 数仓知识库 (LLM Wiki + RAG)

为 AI Agent 提供数据仓库上下文的知识库。支持 **Text-to-SQL 问数 · 数据资产发现 · 业务口径问答 · 数仓开发辅助**。

## 核心理念

**`catalog/` 是唯一事实源 (single source of truth)。** `wiki/`(人读) 与向量索引(RAG) 都从它派生，避免两套知识漂移。

```
数据源 ──extract──> catalog/ (YAML) ──┬─build_wiki──> wiki/ (Markdown, 高精度核心口径)
 Doris/Hive/MySQL    表·字段·指标·     │
                     业务域·术语·血缘   └─build_index─> 向量库 (RAG, 长尾表/字段/SQL样例)
                                                            │
                              二者经 serve/ MCP Server ─────┴──> AI Agent 按需检索
```

机器抽结构(90%) + 人工注入业务语义与踩坑(10%) = 高质量知识。

## 目录

| 路径 | 内容 | 谁来维护 |
|------|------|----------|
| `catalog/tables/` | 表元数据(字段/粒度/踩坑/血缘) | 抽取生成 + 人工补口径 |
| `catalog/metrics/` | 指标定义与口径 | 人工校准(权威) |
| `catalog/domains/` | 业务域地图 | 人工 |
| `catalog/glossary.yaml` | 业务术语表 | 人工 |
| `examples/` | 黄金 SQL 样例(few-shot) | 人工沉淀(Text-to-SQL 最大杠杆) |
| `wiki/` | 派生的人读文档 + 手写规范 | build_wiki 生成 + 手写 guides |
| `pipeline/` | 抽取 / 建 wiki / 建索引脚本 | 工程 |
| `serve/` | MCP server，暴露检索工具给 Agent | 工程 |

## 知识三层

1. **业务层** — 业务域 / 术语 / 指标口径（回答「GMV 怎么算」「新客是谁」）
2. **模型层** — 表 / 字段 / 关系 / 分层（支撑 Text-to-SQL 生成 JOIN）
3. **经验层** — 踩坑(known_issues) / 黄金 SQL 样例（纯抽元数据拿不到，最值钱）

## 给 Agent 的检索约定 (RAG vs 确定性)

| 问题类型 | 取知识方式 |
|----------|-----------|
| 指标口径("GMV 怎么算") | **确定性** `get_metric()` —— 必须精确，不走模糊检索 |
| 术语翻译("新客") | **确定性** `lookup_glossary()` |
| "哪张表有 X" / 长尾表字段 | **RAG** `search_tables()` 语义召回 |
| 写 SQL | **RAG** `search_examples()` 召回相似样例做 few-shot + 取相关表 catalog |

## 头部 vs 长尾的判定与维护策略

数仓的表/字段访问热度呈**长尾分布**：少数「头部」核心表承载绝大多数查询，海量「长尾」表偶尔才用一次。两类知识用两种方式管，这正是 Wiki + RAG 混合架构的根因。

```
访问频率
  ▲ ██
  │ ██ ██          头部：~20% 的表，~80% 的查询
  │ ██ ██ ██
  │ ██ ██ ██ ▆ ▅ ▄ ▃ ▂ ▁ ▁ ▁ ▁ ...   长尾：~80% 的表，每张都很冷
  └────────────────────────────────────▶ 表(按热度排序)
```

### 怎么判定（头部入口）

按优先级，命中任一即视为头部，优先精校：

1. **查询热度** — 取血缘/审计日志近 90 天的表访问次数，Top 20%（或人工定个阈值，如月查询 ≥ N 次）。
2. **指标关联** — 被 `catalog/metrics/` 任一指标 `source_table` 引用的表，天然是头部。
3. **域核心表** — 列入 `catalog/domains/*.yaml` 的 `core_tables`。
4. **分层信号** — `ads_`/`dws_` 应用汇总层多为头部；`ods_` 贴源层不直接消费，不必精校。
5. **跨团队复用** — 被多个下游、多个看板依赖的表（看 `lineage.downstream` 数量）。

字段维度同理：主键、JOIN 键、指标计算列（如 `pay_amount`）、高频过滤/分组列是头部字段，需补 `cn`/`enum`/`desc`/`known_issues`；冷门字段抽到结构即可。

> 工程化建议：在 `catalog/tables/*.yaml` 加一个 `tier: 头部 | 长尾` 字段（可由热度脚本自动回写），`build_wiki`/`build_index` 据此分流。

### 两套维护策略

| | 头部（核心） | 长尾 |
|---|---|---|
| 判定 | 命中上面任一规则 | 其余全部 |
| 知识来源 | 抽取骨架 + **人工精校口径/踩坑** | 抽取**自动生成**，基本不人工 |
| 消费方式 | Wiki 确定性注入；指标走 `get_metric()` | RAG `search_tables()` 语义召回，用到才取 |
| 必填项 | `name_cn`·`grain`·`caliber`·`known_issues`·`relations` | 字段名/类型/`comment` 即可 |
| 评审 | 口径需业务方对齐、版本化 | 无需评审，定期重抽刷新 |
| 投入产出 | 少而精，值得逐张打磨 | 多而杂，靠自动化覆盖 |

### 生命周期：长尾↔头部会流动

- **长尾转头部**：某张表查询量涨上来 / 被新指标引用 → 触发「待精校」清单，补口径与踩坑，`tier` 升为头部。
- **头部转长尾或废弃**：业务下线、连续 N 天零访问 → 降级或标 `status: 已废弃`，从 Wiki 移除但保留 catalog 存档（资产发现仍可查到）。
- **落地动作**：定期跑热度脚本 → diff 出 tier 变化 → 生成「本周需人工补口径的表」清单，把人力精准投到刚变热的表上。

## 快速开始

```bash
pip install pyyaml
python pipeline/build_wiki.py      # catalog -> wiki/tables/*.md
python pipeline/build_index.py     # 预览检索块(向量库部分见 TODO)
python serve/mcp_server.py         # 打印 gmv 指标口径(验证读取)
```

## 扩展指南

- **加一张表**: 复制 `catalog/tables/dwd_trade_order_detail.yaml` 改写，或用 `extract/` 抽骨架后补 `name_cn`/`known_issues`/口径。
- **加一个指标**: 在 `catalog/metrics/` 加 YAML，务必写清 `caliber`(口径) 和 `synonyms`(口语叫法)。
- **加一个域**: `catalog/domains/` 加 YAML，列出 `core_tables` / `core_metrics`。
- **关键原则**: 口径(caliber)和踩坑(known_issues)是知识库的灵魂，结构(字段类型)能自动抽，**口径必须人工对齐业务**。
