# BI 指标知识库 · 整体设计文档

> 本文是本项目的**权威蓝图**，描述我们实际的系统现状与口径链路。
> （`README.md` 是通用脚手架说明；本文是针对我们这套真实架构的设计。）

---

## 1. 背景与目标

**一句话**：我们不缺指标定义，缺的是把散在 4 个系统里的口径**缝成一张可被 AI Agent 一次查到的图**。

最初的判断是"我们压根没有指标定义"。经过逐层排查，结论相反：

> 每个报表数字的完整口径**一直都存在**，只是被切成 4 段、分别埋在前端代码、MySQL、Doris/SR、ETL 系统里，从没有人把它们串起来。

**知识库的唯一核心价值** = 把下面这条**跨 4 系统的口径链**缝合成一张图，让 Agent（或人）回答"这个数怎么算的 / 准不准 / 来自哪"时，一条链就给全，不必跳 4 个系统翻。

**支撑的 Agent 场景**：Text-to-SQL 问数 · 数据资产发现 · 业务口径问答 · 数仓开发辅助。

---

## 2. 现状盘点（数据来自 `chart-index.generated.json` 实测）

| 项 | 数量 | 说明 |
|---|---|---|
| 展示指标条目 | 842 | 前端扫描产出 |
| 逻辑指标(唯一 key) | **160** | 842 = 160 × 不同产品线 scope 的重复 |
| 有计算公式(measures) | 720 (85%) | 机器口径 |
| 有人话口径(hint) | 351 (42%) | ← 缺口：491 个没有 |
| 有 dataSetId | 671 (80%) | → 接 MySQL SQL |
| 唯一 dataSetId | **141** | 要从 MySQL 捞 SQL |
| 底层指标词汇(并集) | **~355** | indicator_map 的 key ∪ 公式裸列名 |

底层指标使用频次**极不均匀**（Pareto）：`active_cnt`(211) · `pay_amt`(149) · `register_cnt`(85) · `day_cnt`(66) · `pcu`(58) · `acu`(58) …少数头部覆盖绝大多数公式。

---

## 3. 核心：四层口径模型

```
A. 展示指标 (160个)          来源: chart-index.generated.json (前端代码扫描)
   月均活跃度 = sum(indicator_map['avg_active_cnt']) / sum(indicator_map['mau'])
        │ 公式引用 indicator_map 的 key
        ▼
B. 底层指标 (~355个)         公式引用的名字，有【两种取法】：
                            ① indicator_map 的 key   ：indicator_map['avg_active_cnt']
                            ② 表的直接来源列(裸列名)  ：pcu / acu / sum(pure_register_cnt)
                            （同一指标可能两种都有，如 mau / pure_register_cnt）
        │ 都来自
        ▼
C. Doris/SR 宽表             宽表同时提供: indicator_map(MAP 列) + 若干直接列；datasetId 的 SQL select 它
        │ 由…构建
        ▼
D. ETL 任务                  ⭐ 底层指标"到底怎么算"的终极口径在这
                            异构: SQL 任务 / Flink 任务 / Spark JAR 任务
```

**口径链条**：A 是 B 的公式 → B 是 C 宽表的 MAP key → C 由 D 的 ETL 构建。

每层口径真相所在与可获取性：

| 层 | 口径真相在哪 | 来源系统 | 可获取性 |
|---|---|---|---|
| A 展示指标 | 公式(`measures`) + `hint` | chart-index.json | ✅ 已在手 |
| B 底层指标(名) | map key + 表直接列 | Doris/SR 宽表 `map_keys` + 列清单 | ✅ 可枚举 |
| C 宽表↔datasetId | dataset 的 SQL | MySQL | ✅ 可 select |
| D 底层指标(含义) | ETL 任务逻辑 | ETL 调度系统 | ✅ 可获取（难度因任务类型而异） |

**关键结论：没有一层的口径是"只在某人脑子里"，全部有可访问来源。**

---

## 4. 数据源与抽取方案（逐层）

### A 层 · 展示指标 —— 🟢 易（纯解析）

- **输入**：`chart-index.generated.json`
- **做法**：解析 842 entries → 按 `key` 归并成 160 个逻辑指标；每个指标抽出 `title / key / measures(公式) / dataSetId / rows·columns·filters(维度) / hint / scope / category`。
- **副产物**：扫描所有公式，提取底层指标名并**按频次排序** → 生成 B 层工单清单（D 层优先级依据）。

### C 层 · datasetId → SQL —— 🟡 中（需 MySQL 权限）

- **输入**：MySQL 里 datasetId→SQL 的元数据表（141 条）。
- **做法**：拉全部 SQL，按 datasetId 挂到 A 层指标上；解析 SQL 的 `FROM` 得到所读 **Doris/SR 宽表**（C 层物理载体）。

### B 层 · 底层指标名 —— 🟢 易（枚举）

底层指标在公式里有**两种取法**，枚举时都要覆盖：

- **① map key**：对宽表 `SELECT DISTINCT map_keys(indicator_map)` 取全集。
- **② 直接来源列**：宽表的普通列（裸列名，如 `pcu`/`acu`），从 `information_schema.columns` / `DESC table` 取。
- 两者并集 = B 层全集；同一指标可能两种都出现（如 `mau`）。每个底层指标记录其 `source_type: map_key | direct_column`，因为这影响 SQL 取数写法。
- 含义留给 D 层补。

### D 层 · ETL 口径 —— 🔴 难，且**异构**，按任务类型分层处理

D 层是知识库**最深、最值钱、也最难**的一层。ETL 任务有三类，抽取策略完全不同：

| 任务类型 | 抽取难度 | 策略 |
|---|---|---|
| **SQL 任务** (Spark SQL / Hive SQL) | 🟡 可解析 | 解析 SQL，定位 `... AS avg_active_cnt` 的算法表达式；跟 dataset SQL 同套解析器 |
| **Flink 任务** | 🟠 看形态 | Flink SQL → 可解析；Flink DataStream(代码) → 退化为元数据+源码阅读 |
| **Spark JAR 任务** | 🔴 难 | 已编译 Scala/Java，无法静态解析口径；只能靠任务说明/注释/源码仓 + LLM 辅助 + 人工 |

**两个难点必须正视**：

1. **跨多跳**：一个底层指标可能经 明细表 → 轻聚合 → map 宽表 2~3 段 ETL 才成型，需顺血缘追几跳。
2. **异构兜底**：Spark JAR / Flink 代码类任务无法自动抽口径 → 对这部分指标，知识库**只记录"算法在哪个任务/代码位置" + 人工/LLM 沉淀的口径草稿**，不强求自动化。

**降难度的核心策略 —— 按频次自上而下（Pareto）**：
不追求 355 个底层指标全做。用 A 层算出的频次排序，**优先攻头部几十个高频指标**（它们覆盖绝大多数公式），其余长尾随用随补。这与"头部 vs 长尾"策略一致。

---

## 5. 知识库存储设计

**catalog 仍是唯一事实源**，但指标实体扩展为**承载四层链接**的结构。每个指标一份 YAML：

```yaml
# catalog/metrics/month_avg_activation.yaml  (示意)
metric: month_avg_activation
name_cn: 月均活跃度
# --- A 层: 展示指标 ---
formula: "sum(indicator_map['avg_active_cnt']) / sum(indicator_map['mau'])"
hint: "自然月粒度下，月均DAU/MAU = (sum(月每日活跃)/月总天数) / 月去重活跃"   # 42%已有, 缺的LLM补
dimensions: [logymd]
filters: getCommonMonthlyFixedFilters
category: core-dau
scopes: [mlbb, sgame_cn, ...]          # 同一指标的产品线
source_ref: "src/views/.../const.ts:102"
# --- B 层: 引用的底层指标 ---
base_indicators: [avg_active_cnt, mau]
# --- C 层: 数据来源 ---
dataset_id: "300016"
dataset_sql_ref: "mysql://meta/t_dataset#300016"
wide_table: "doris.dws_xxx_indicator_wide"
# --- D 层: 终极口径 ---
etl:
  - base: avg_active_cnt
    task: "spark_sql://etl/dws_xxx_indicator_wide"
    task_type: spark_sql            # spark_sql | flink_sql | flink_jar | spark_jar
    algo: "active_cnt / day_cnt"    # 抽到则填，抽不到留 task 指针 + 人工草稿
    status: 已确认 | 草稿 | 待补
```

底层指标单独建字典（复用度最高）：

```yaml
# catalog/base_indicators/avg_active_cnt.yaml
key: avg_active_cnt
name_cn: 日均活跃
source_type: map_key                  # map_key | direct_column —— 影响 SQL 取数写法
usage_count: 23                       # 被多少展示指标引用 → 优先级
algo: "active_cnt / day_cnt"          # 来自 D 层 ETL
defined_in: "spark_sql://etl/dws_xxx_indicator_wide"
status: 已确认
```

**口径图 · 两类节点**：知识库有**两大支柱**，是同一张图里相连的两类节点——

- **指标节点**：`metrics/`(展示指标) + `base_indicators/`(底层指标)
- **表节点**：`tables/`（C 层 Doris/SR 宽表 + D 层物理源表）

边 = A→B→C→D 的四层引用（指标 `dataset_id/wide_table` 指向表，表 `lineage.used_by_metrics` 反指指标）。
表节点**不只服务指标口径链，也独立支撑** Text-to-SQL(要表结构)、数据资产发现(找表)、数仓开发(懂表)。
存成图（先 YAML 交叉引用，规模大了上图库），Agent 查任一节点（指标**或表**）可沿边回溯。

表节点 schema（`catalog/tables/*.yaml`，由 `extract_metadata.py` 读 Doris/SR information_schema 抽取）要点：
`engine/layer/grain/字段(含 indicator_map MAP 列说明)/contains_base_indicators(in_map+as_column)/lineage(upstream→源表, built_by→ETL, used_by_metrics→指标)`。

---

## 6. Agent 消费方式

沿用 **Wiki + RAG 混合**（详见 README）：

| 问题 | 取知识方式 |
|---|---|
| "月均活跃度怎么算" | 确定性取指标 YAML，**沿四层链返回完整口径**（公式→底层指标→宽表→ETL算法） |
| "avg_active_cnt 是什么" | 确定性取 base_indicators 字典 |
| "哪个指标和留存有关" | RAG 语义检索（title/hint/category） |
| 写 SQL | RAG 召回相似指标 + 其 dataset SQL 做 few-shot |

通过 `serve/mcp_server.py` 暴露为 Agent 工具：`get_metric` / `get_base_indicator` / `search_metrics` / `trace_lineage`。

**头部 vs 长尾**：160 个展示指标 + 355 个底层指标都按使用频次分级；头部人工精校四层口径，长尾自动抽取 + RAG 兜底。

---

## 7. Text-to-SQL 取数策略（决策：默认宽表 + 明细兜底）

**决策**：默认查**上层宽表(C 层)**；仅当宽表没有对应 `指标 × 维度 × 粒度` 时，降级查**原始明细**。

**理由**（核心）：口径藏在 ETL(D 层)。查宽表 = 取 ETL 已烤好的口径，**与现有报表天然一致**；查明细 = 让 LLM 在 SQL 里重算口径，**极易出错**——这正是本知识库要规避的。问数最忌"AI 算的与报表对不上"。

**C 层是一体的**：datasetId 的 dataset SQL **查的就是 doris 宽表**（不是两个东西）。完整产线 = `dataset SQL(取宽表行, 过滤/scope 已写对)` + `measure 公式(Java 套在结果上算, 形如 sum(indicator_map['x'])/...)`。

**走宽表的正确姿势 = 复用 dataset SQL，别重写**：
```
宽表路径 SQL =
   SELECT <measure 公式>              -- 把 Java 的 measure 下推成 SQL 聚合
   FROM ( <dataset SQL 原文> ) t      -- 直接复用, 过滤/scope/口径它已写对
```
> 切忌让 LLM 对宽表现写新的 WHERE —— 那是在重造 dataset SQL 已写好的过滤，反而引入口径偏差。包住 dataset SQL，生成的数与报表走同一条 SQL 路径，天然一致。

**路由规则**：
```
① 宽表(=某 datasetId)里有 (指标 × 这些维度 × 这个粒度) 吗？
     有 → 走宽表：复用 dataset SQL + 套 measure 公式   ← 覆盖绝大多数 BI 问数
     没有 ↓
② 降级走明细：注入 D 层 algo + known_issues(踩坑)，让 LLM 按权威口径重算，而非瞎猜
```

**两路各用知识库哪块**：

| 路径 | 用到的知识 |
|---|---|
| 走宽表(默认) | `metrics.dataset_id`→**dataset SQL 原文** + `metrics.formula`(measure 公式) + 取数写法 `indicator_map['x']` |
| 走明细(兜底) | `base_indicators.algo`(D 层 ETL 口径) + 物理源表 schema + `known_issues` |

> 决策**不改知识库结构**，只改取数时优先读哪些节点。

**Golden SQL 样例**（`examples/golden_queries.yaml`）：默认照宽表路径写，要覆盖 `indicator_map['x']` 这种**非标取数语法**（LLM 必须被样例教会），是 Text-to-SQL 准确率最大的杠杆。

**约束**：宽表按固定粒度/scope 预聚合；宽表维度覆盖越全，能走"安全路径"的问题越多——反向指导数仓该把哪些维度沉淀进宽表。

## 8. 实施路线图

| 阶段 | 内容 | 依赖 | 产出 |
|---|---|---|---|
| **P1** A 层解析 | chart-index → 160 指标卡片 + 底层指标频次清单 | 无（现在就能做） | 指标库 v0 + D 层工单 |
| **P2** C 层接入 | 拉 MySQL 141 条 dataset SQL，挂到指标，解析出宽表 | MySQL 权限 | 指标↔宽表 数据血缘 |
| **P3** B 层枚举 | Doris/SR 宽表 map_keys 取全集，建 base_indicators 字典骨架 | Doris/SR 权限 | 底层指标字典(空含义) |
| **P4** D 层口径 | 按频次攻头部底层指标：SQL任务解析 + Flink/JAR 人工+LLM | ETL 系统访问 | 终极口径（头部已确认） |
| **P5** 缝合服务 | 四层连成口径图，接 RAG + MCP | P1-P4 | Agent 可查完整口径链 |

**先做 P1**：零依赖、纯增益，建完即可见"指标库一直都在"，并产出后续工单。

---

## 9. 关键风险与取舍

- **D 层异构兜底**：Spark JAR / Flink 代码类任务无法自动抽口径，接受"指针 + 人工草稿"，不追求 100% 自动化。
- **跨多跳血缘**：底层指标可能跨 2-3 段 ETL，追链有成本 → 只对头部指标深追。
- **口径漂移**：四层分属不同系统、不同团队，任一层改动都可能使知识库过期 → 需定期重抽 + 标 `status/version`，并记录"最后校准时间"。
- **不强求大而全**：以频次驱动，头部精校、长尾兜底，避免陷入 355 个底层指标逐个考据的泥潭。
