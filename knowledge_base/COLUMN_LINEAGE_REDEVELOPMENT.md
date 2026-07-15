# 列级生产逻辑恢复：重新开发需求草案

> 状态：已同意按本文档逐步实现；当前处于阶段 B（单任务列逻辑模型）。  
> 未明确确认的待办项仍保留，不在实现中擅自扩大范围。

## 1. 背景

项目需要从已有 ETL SQL 中追溯一个目标列的真实生产逻辑，并恢复能够阅读、核对和执行的生产 SQL。

前期原型同时引入了 producer、definition、override、全路径枚举、SQL bundle 等概念。它们解决了部分技术问题，但也把以下三类信息混合在了一起：

1. 目标列的值从哪里来、怎样计算；
2. 哪些表、过滤、JOIN、分组影响最终结果的行集合；
3. 系统内部如何存储和选择 producer。

最终输出因此更接近“内部血缘图”，而不是用户真正需要的“字段生产逻辑”。本轮重新开发首先明确产品目标和验收标准，再决定数据模型及实现方式。

## 2. 核心目标

给定一个明确的生产任务和目标字段，系统必须回答：

1. 目标字段由哪个任务生产；
2. 哪些物理字段真正参与目标值的计算；
3. 值经过了哪些表达式、聚合和中间字段；
4. 哪些 JOIN、WHERE、GROUP BY 和 UNION 分支影响结果；
5. 每个 UNION 分支对目标字段的具体贡献是什么；
6. 是否可以恢复一条字段范围内的生产 SQL；
7. 如果不能完整恢复，具体缺失在哪一层、缺少什么信息。

核心交付物不是完整血缘图，而是：

- 一份结构化的字段生产逻辑；
- 一份经过裁剪的字段生产 SQL。

## 3. 暂不作为核心目标的功能

以下功能可以保留为内部能力或后续功能，但不作为第一阶段主流程：

- 展示所有内部 definition 节点；
- 默认枚举同一物理字段的所有 producer；
- 要求普通用户手工填写 override；
- 把多个任务的完整原始 SQL 直接拼接输出；
- 仅输出表级血缘；
- 在当前阶段同时维护 PostgreSQL 与 Neo4j 两套存储模型；
- 一次性解决所有 SQL 方言及所有异常 SQL。

### 3.1 存储选型决定

当前阶段统一使用 **PostgreSQL** 完成 lineage 的建模、存储和查询。

本阶段的技术边界：

- PostgreSQL 是当前唯一的 lineage 持久化存储；
- 生产任务、数据集、字段、表达式、依赖和 producer 信息均存入 PostgreSQL；
- 单任务列切片、跨任务递归和 producer 选择均先基于 PostgreSQL 实现；
- 当前数据模型和业务接口不依赖 Neo4j；
- 当前阶段不建设 PostgreSQL 与 Neo4j 的双写、同步或一致性机制。

Neo4j 放到项目主体功能基本完成之后，再进行独立的图模型设计。届时主要评估：

- PostgreSQL lineage 模型向图节点、图关系的映射；
- 多跳路径查询和影响分析；
- 血缘图可视化；
- 大规模图遍历性能；
- PostgreSQL 与 Neo4j 的数据同步方式。

后续引入 Neo4j 时，不应推翻已经确认的字段生产逻辑语义。Neo4j 是新的存储和查询实现，不改变“值依赖、计算上下文、行集合依赖、常量分支”等核心业务模型。

## 4. 核心概念

### 4.1 生产任务

生产任务是一次明确的 SQL 生产行为，例如任务 `100021029`。

同一物理表和同一字段可能被多个任务写入。因此，只有 `表名.字段名` 不能唯一确定生产逻辑。

第一阶段的标准输入必须包含任务标识。

### 4.2 目标字段

目标字段是本次需要恢复生产逻辑的物理输出列，例如：

```text
mt_ads.ads_gamebi_roger_primary_di.active_cnt
```

### 4.3 值依赖

值依赖是实际参与目标字段数值计算的字段或表达式。

例如：

```sql
IF(SUBSTRING(active_info, 1 + diffdays, 1) > 0, 1, 0) AS is_active
```

其中：

- `active_info` 是业务值来源；
- `diffdays` 是计算参数；
- `is_active` 是中间计算结果。

### 4.4 计算上下文依赖

计算上下文依赖不会直接贡献最终数值，但会影响值如何计算或哪些行参与计算，包括：

- JOIN key；
- WHERE 过滤字段；
- GROUP BY 维度；
- 窗口函数的 PARTITION BY / ORDER BY 字段；
- 日期序列或辅助 CTE。

例如任务 `100021029` 中，`date_list.logymd` 用来计算 `diffdays`，属于计算上下文依赖。

### 4.5 行集合依赖

行集合依赖决定最终输出有哪些行，但不一定贡献目标字段的值。

例如 UNION 分支：

```sql
SELECT ..., 0 AS active_cnt
FROM mt_ads.ads_gamebi_create_reten_ltv_df
```

该表参与最终结果的行集合，但在此分支对 `active_cnt` 的值贡献恒为 `0`。

### 4.6 常量分支

当一个 UNION 分支对目标字段输出常量时，应明确记录：

```text
来源表：mt_ads.ads_gamebi_create_reten_ltv_df
目标贡献：0 AS active_cnt
依赖类型：constant_branch
```

不能因为其值为 `0` 就完全删除该分支，否则会改变最终行集合；也不能把该表描述成 `active_cnt` 的业务值来源。

### 4.7 外部边界

当追溯到一个物理源表，而当前元数据中没有该表的生产任务时，该表是正常的外部边界。

外部边界不等于失败。例如：

```text
adbi.dm_sdk_device_multi_behavior_ug_df.active_info
```

如果系统已经恢复到这里，则可以认为当前范围内追溯完整。

### 4.8 解析缺口

解析缺口表示原 SQL 中存在逻辑，但解析模型没有建立完整依赖。

需要区分：

1. 原 SQL 仍可通过 AST 恢复：记录为 `recovered_from_raw_sql`，不阻断 SQL 生成；
2. 原 SQL 本身缺失或无法解析：记录为 `unresolved`，阻断完整 SQL 生成。

例如 SQL 内部通过 `EXPLODE` 生成的 `p_date`，即使字段血缘表中没有来源边，只要原 SQL 完整，就不应把整条链路判定为失败。

## 5. 第一阶段标准输入

建议的命令接口：

```bash
uv run python -m metawiki.pipeline.p4_field_logic \
  --column-sql \
  --job-id 100021029 \
  --target mt_ads.ads_gamebi_roger_primary_di.active_cnt
```

输入要求：

| 参数 | 必填 | 说明 |
|---|---:|---|
| `--job-id` | 是 | 明确选择生产任务，避免同字段多 producer 歧义 |
| `--target` | 是 | 完整目标字段，格式为 `schema.table.column` |
| `--dialect` | 否 | 默认从任务元数据读取 Hive/Spark 方言 |
| `--output-dir` | 否 | 指定结果目录 |

如果 `job-id + target` 不匹配，应直接返回明确错误，不进行猜测。

## 6. 第一阶段标准输出

建议输出目录：

```text
generated/column_logic/100021029/active_cnt/
├── column_logic.json
└── production.sql
```

### 6.1 column_logic.json

建议结构：

```json
{
  "target": {
    "job_id": "100021029",
    "dataset": "mt_ads.ads_gamebi_roger_primary_di",
    "field": "active_cnt"
  },
  "value_sources": [],
  "context_sources": [],
  "transformations": [],
  "branches": [],
  "grain": [],
  "external_boundaries": [],
  "recovered_boundaries": [],
  "unresolved_boundaries": [],
  "complete": true
}
```

字段含义：

| 字段 | 含义 |
|---|---|
| `value_sources` | 真正参与目标值计算的物理字段 |
| `context_sources` | JOIN、过滤、日期差、分组等辅助字段 |
| `transformations` | 从源字段到目标字段的表达式链 |
| `branches` | UNION 每个分支对目标字段的贡献 |
| `grain` | 目标结果的分组维度或明细粒度 |
| `external_boundaries` | 没有更上游 producer 的正常物理源 |
| `recovered_boundaries` | lineage 模型缺失，但已从原 SQL AST 恢复的逻辑 |
| `unresolved_boundaries` | 无法从 lineage 或原 SQL 恢复的真实缺口 |
| `complete` | 是否足以生成可信的字段生产 SQL |

### 6.2 production.sql

SQL 必须满足：

1. 只投影目标字段以及维持语义必需的维度列；
2. 删除同一任务中与目标字段无关的其他指标；
3. 保留必要的 CTE、JOIN、WHERE、GROUP BY 和窗口定义；
4. 保留所有影响最终行集合的 UNION 分支；
5. UNION 分支只保留目标字段和对齐所需维度；
6. 不出现悬空 CTE、别名或缺失列；
7. 生成后必须再次解析验证；
8. 有条件时，应验证生成 SQL 的叶子源与结构化逻辑一致。

## 7. 任务 100021029 的验收样例

### 7.1 目标

```text
job_id: 100021029
target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
```

### 7.2 预期业务值来源

```text
adbi.dm_sdk_device_multi_behavior_ug_df.active_info
```

### 7.3 预期计算上下文

日期 CTE 生成回刷日期：

```text
date_list.p_date
date_list.logymd
```

日期差：

```sql
DATEDIFF('2026-05-31', c.logymd) AS diffdays
```

LEFT JOIN：

```sql
FROM adbi.dm_sdk_device_multi_behavior_ug_df a
LEFT JOIN date_list c
  ON a.p_date = c.p_date
```

### 7.4 预期表达式链

```text
active_info
→ SUBSTRING(active_info, 1 + diffdays, 1)
→ IF(... > 0, 1, 0)
→ is_active
→ SUM(is_active)
→ active_cnt
→ COALESCE(SUM(active_cnt), 0)
→ 最终 active_cnt
```

### 7.5 预期 UNION 分支

分支一：真实值分支

```text
source: adbi.dm_sdk_device_multi_behavior_ug_df
expression: SUM(is_active) AS active_cnt
dependency_type: value
```

分支二：新增留存行集合

```text
source: mt_ads.ads_gamebi_create_reten_ltv_df
expression: 0 AS active_cnt
dependency_type: constant_branch
```

分支三：活跃留存行集合

```text
source: mt_ads.ads_gamebi_active_reten_di
expression: 0 AS active_cnt
dependency_type: constant_branch
```

### 7.6 预期粒度

目标 SQL 应保留原始聚合粒度：

```text
date_range
country
os
network
logymd
```

是否在最终 SELECT 中展示全部粒度列，需要在“待确认事项”中决定；但内部 GROUP BY 语义必须保留。

### 7.7 预期结构化结果示例

```json
{
  "target": {
    "job_id": "100021029",
    "dataset": "mt_ads.ads_gamebi_roger_primary_di",
    "field": "active_cnt"
  },
  "value_sources": [
    {
      "dataset": "adbi.dm_sdk_device_multi_behavior_ug_df",
      "field": "active_info"
    }
  ],
  "context_sources": [
    {
      "dataset": "date_list",
      "field": "logymd",
      "usage": "calculate_diffdays"
    }
  ],
  "transformations": [
    "DATEDIFF('2026-05-31', c.logymd) AS diffdays",
    "IF(SUBSTRING(active_info, 1 + diffdays, 1) > 0, 1, 0) AS is_active",
    "SUM(is_active) AS active_cnt",
    "COALESCE(SUM(active_cnt), 0) AS active_cnt"
  ],
  "branches": [
    {
      "source": "adbi.dm_sdk_device_multi_behavior_ug_df",
      "expression": "SUM(is_active) AS active_cnt",
      "dependency_type": "value"
    },
    {
      "source": "mt_ads.ads_gamebi_create_reten_ltv_df",
      "expression": "0 AS active_cnt",
      "dependency_type": "constant_branch"
    },
    {
      "source": "mt_ads.ads_gamebi_active_reten_di",
      "expression": "0 AS active_cnt",
      "dependency_type": "constant_branch"
    }
  ],
  "grain": ["date_range", "country", "os", "network", "logymd"],
  "complete": true
}
```

## 8. 单任务恢复算法

第一阶段仅处理一个明确 job 内部的 SQL。

### 8.1 定位目标输出

1. 根据 `job-id` 读取原始 SQL；
2. 解析 INSERT 的目标表、静态/动态分区和查询体；
3. 校验目标表与 `--target` 一致；
4. 根据列名或目标表 schema 定位目标 SELECT 位置。

### 8.2 反向列切片

从目标字段开始递归：

```text
最终 SELECT
→ 子查询
→ UNION 对应列
→ CTE
→ 中间表达式
→ 物理字段
```

每一层需要计算：

- 当前 SELECT 必须保留哪些投影；
- 表达式引用了哪些输入列；
- WHERE/HAVING 引用了哪些列；
- JOIN 条件引用了哪些列和关系；
- GROUP BY 使用了哪些粒度列；
- 窗口函数依赖哪些分区列和排序列；
- UNION 的目标列在各分支中对应哪个位置。

### 8.3 UNION 处理

对 UNION 的目标列按位置对齐，并为每个分支分类：

- `value`：引用物理字段或中间计算字段；
- `constant_branch`：常量、NULL、固定数组等；
- `passthrough`：直接透传上游同名或异名字段；
- `unknown`：无法解析。

不能因为目标表达式是常量就删除整个分支。

### 8.4 JOIN 处理

只要 JOIN 会影响目标字段所在结果的行集合，就必须保留。

需要区分：

- JOIN 右表字段直接参与目标值计算；
- JOIN 右表只提供计算参数；
- JOIN 仅影响行是否存在或重复；
- JOIN 实际被 WHERE 条件转化为半连接、反连接或内连接语义。

### 8.5 完整性判断

`complete=true` 的最低条件：

1. 找到目标输出表达式；
2. 所有必需 CTE/子查询可从原 SQL 恢复；
3. UNION 各分支目标位置已解析；
4. 没有悬空列、关系或别名；
5. 生成 SQL 可被目标方言重新解析；
6. 所有未继续追溯的节点都是明确的物理外部边界。

## 9. 第二阶段：跨任务递归

单任务恢复稳定后，再实现跨任务。

当单任务切片到达物理字段时：

1. 查询该字段的 producer；
2. 从表元数据动态获取该物理表的全部分区键；
3. 从下游读取 SQL 中提取这些分区键的约束；
4. 从每个上游 producer 的写入 SQL 中提取分区写入信息；
5. 对上下游分区约束进行兼容性匹配；
6. 唯一匹配时进入上游任务继续做单任务字段切片；
7. 多个匹配时返回候选、匹配分数及具体依据；
8. 没有 producer 时记录为正常外部边界。

跨任务的核心仍是“重复执行单任务字段切片”，而不是拼接完整 job SQL。

## 10. producer 选择原则

producer 必须按照**通用分区信息**选择，不能在代码中写死 `appname`、`granularity_type`、`date_type`、`logymd` 等字段名。

这些字段只是当前部分表的分区示例。其他表可能使用任意分区键，例如：

```text
dt
ds
hour
region
platform
tenant_id
game_id
zone_type
biz_date
```

也可能使用多级组合分区。producer 匹配逻辑必须对任意分区字段生效。

### 10.1 分区键来源

分区键优先从表元数据或建表 DDL 获取，而不是通过固定字段名猜测。

每张物理表需要记录：

```json
{
  "dataset": "schema.table",
  "partition_keys": [
    {"name": "biz_date", "ordinal": 1, "data_type": "string"},
    {"name": "region", "ordinal": 2, "data_type": "string"}
  ]
}
```

如果没有可靠的表分区元数据，可以从 INSERT PARTITION、DDL 或历史任务中推断，但必须标记来源和可信度。

### 10.2 上游写入分区提取

系统需要从 producer SQL 中提取完整写入分区，而不是只提取几个常见字段。

静态分区示例：

```sql
INSERT OVERWRITE TABLE target
PARTITION(biz_date='2026-07-15', region='us', tenant_id='1001')
```

提取为：

```json
{
  "biz_date": {"type": "eq", "value": "2026-07-15"},
  "region": {"type": "eq", "value": "us"},
  "tenant_id": {"type": "eq", "value": "1001"}
}
```

动态分区示例：

```sql
INSERT OVERWRITE TABLE target
PARTITION(biz_date, region)
SELECT ..., log_date AS biz_date, country_group AS region
```

系统需要把动态分区键映射到 SELECT 尾部的对应表达式，不能只记录为“动态分区”。

### 10.3 下游读取分区提取

系统根据表的真实分区键，从下游读取 SQL 的 WHERE 条件中提取约束，例如：

```sql
WHERE biz_date = '2026-07-15'
  AND region IN ('us', 'ca')
  AND hour BETWEEN '00' AND '12'
```

至少需要支持：

- 等值：`=`；
- 集合：`IN`；
- 范围：`BETWEEN`、`>`、`>=`、`<`、`<=`；
- 多分区键的 AND 组合；
- 可确定值的常量表达式；
- 模板变量或运行参数；
- 无法静态求值的动态表达式。

只有表元数据中声明为分区键的字段才进入 producer 分区匹配。普通业务过滤字段不能误当成分区条件。

### 10.4 分区约束模型

建议将每个分区键统一表示为约束：

```text
eq(value)
in(values)
range(lower, upper)
dynamic(expression)
unknown
```

对上下游约束进行兼容性判断：

- `compatible`：存在交集，可以成为候选 producer；
- `exact`：所有已知分区约束完全一致；
- `partial`：部分分区键匹配，其他分区键未知；
- `conflict`：至少一个分区键明确无交集，必须排除；
- `unknown`：信息不足，不能自动选中，也不能直接判定冲突。

示例：

```text
下游读取：region IN ('us', 'ca')
上游写入：region = 'us'
结果：compatible

下游读取：region = 'us'
上游写入：region = 'eu'
结果：conflict，排除该 producer
```

### 10.5 选择流程

producer 选择流程：

1. 获取目标物理表的全部分区键；
2. 提取下游对每个分区键的读取约束；
3. 提取所有候选 producer 的完整写入分区约束；
4. 排除任何存在明确分区冲突的 producer；
5. 根据匹配覆盖率、精确程度和未知分区数量进行排序；
6. 只有唯一最佳候选时才自动选择；
7. 最佳候选并列或信息不足时，返回候选及分区对比，不静默选择；
8. 人工选择仅作为最后兜底。

每次自动选择必须输出可解释依据，例如：

```json
{
  "selected_producer": "job.123",
  "reason": "partition_exact_match",
  "partition_comparison": {
    "biz_date": {"read": "2026-07-15", "write": "2026-07-15", "status": "exact"},
    "region": {"read": ["us", "ca"], "write": "us", "status": "compatible"}
  }
}
```

调度依赖和任务实例关系可以用于同分区候选之间的辅助判断，但不能覆盖明确的分区冲突。

`override` 仅作为内部调试或最终兜底，不作为标准使用流程。

## 11. 第三阶段以后

在单任务和跨任务恢复稳定后，才考虑：

- 自动生成所有候选生产路径；
- 为每条候选路径生成 SQL；
- 对路径进行分区兼容性评分；
- 项目主体完成后，再进行 Neo4j 图模型、图查询与可视化；
- 大规模离线预计算；
- Wiki 或指标平台集成。

## 12. 验收标准

### 12.1 必须满足

- 输入任务和目标字段后，可稳定定位唯一生产逻辑；
- producer 选择基于表的任意分区键，不依赖固定分区字段名单；
- 明确冲突的分区 producer 不得被自动选中；
- producer 自动选择结果必须提供逐分区键的解释；
- 能区分值来源、上下文依赖和常量分支；
- 能正确处理 CTE、子查询、JOIN、GROUP BY、窗口函数和 UNION；
- SQL 不包含无关指标列；
- SQL 保持原始行集合和聚合语义；
- SQL 可重新解析；
- 输出中不要求用户理解 definition ID；
- 任务 `100021029.active_cnt` 的结果符合第 7 节。

### 12.2 不允许出现

- 用完整原始 job SQL 冒充字段恢复 SQL；
- 把 `0 AS active_cnt` 的来源表描述成业务值来源；
- 因内部日期 CTE 没有 lineage 边就判定整条 SQL 无法恢复；
- 生成悬空的 CTE、别名、JOIN 或列；
- 默认展示大量内部 ID 而不解释业务含义；
- 在生产逻辑尚未确认时自动选择明显不兼容的 producer。

## 13. 建议开发阶段

### 阶段 A：冻结需求

- 人工修改本文档；
- 明确待确认事项；
- 确认任务 `100021029.active_cnt` 的期望结果；
- 文档状态改为 `Approved`。

### 阶段 B：单任务列逻辑模型

- 定义 `column_logic.json` schema；
- 实现依赖类型分类；
- 实现 AST 反向切片；
- 完成任务 `100021029` 验收测试。

### 阶段 C：扩大单任务测试集

至少覆盖：

- 直接字段透传；
- CASE/IF；
- 聚合；
- 窗口函数；
- 多层 CTE；
- UNION 常量分支；
- LEFT JOIN 参数表；
- 反连接；
- SELECT *；
- 静态和动态分区。

### 阶段 D：跨任务递归

- producer 查询；
- 分区上下文匹配；
- 多 job SQL 拼接；
- 外部边界和真实缺口分类。

### 阶段 E：辅助功能

- 所有路径枚举；
- 批量 SQL 生成；
- Wiki 集成。

### 阶段 F：Neo4j 建模

该阶段必须在 PostgreSQL 版本的主体功能基本完成后开始：

- 将已确认的 PostgreSQL lineage 模型映射为 Neo4j 图模型；
- 设计节点、关系、索引和唯一约束；
- 实现 PostgreSQL 到 Neo4j 的同步或离线构建；
- 验证多跳追溯、影响分析和可视化能力；
- 对比 PostgreSQL 与 Neo4j 的查询结果一致性。

## 14. 待确认事项

请直接修改以下内容。确认后再开始开发。

1. 标准输入是否确定为 `job-id + target field`？
2. `job-id` 使用 `100021029` 还是内部格式 `job.100021029_0`？
3. 最终 SQL 是否需要输出粒度列，还是只输出目标字段？
4. `production.sql` 的目标是：
   - 可直接运行的 SELECT；
   - 可直接写表的 INSERT；
   - 两者都需要？
5. UNION 的常量分支是否必须完整保留所有过滤和维度？
6. 是否需要在 JSON 中分别展示：
   - 值来源；
   - 上下文来源；
   - 行集合来源；
   - 常量分支？
7. 物理源表没有 producer 时，是否统一视为正常完成边界？
8. 原 SQL 可恢复、lineage 表不可恢复时，是否允许标记为完整？
9. 第一阶段需要支持 Hive 和 Spark，还是先只支持 Hive？
10. 第一阶段还需要哪些验收任务和字段？
11. 分区键元数据的权威来源是什么：Hive Metastore、建表 DDL、现有 catalog，还是组合来源？

## 15. 文档确认记录

| 日期 | 修改人 | 状态 | 说明 |
|---|---|---|---|
| 2026-07-15 | 待填写 | Draft | 初始需求草案，等待修改 |
| 2026-07-15 | 待填写 | Draft | 确认当前使用 PostgreSQL；Neo4j 延后到主体功能完成后建模 |
| 2026-07-15 | 待填写 | Draft | producer 按任意分区键动态匹配，不写死具体分区字段 |
| 2026-07-15 | 待填写 | Implementing | 开始阶段 B；先实现 job-id + target 的单任务字段逻辑与 SQL |
