# build_lineage

`build_lineage` 是列级生产逻辑恢复的全新、独立实现。

本目录从零开始建设，不把旧的 `metawiki.lineage` 当作运行时依赖。旧实现只作为问题样例和历史参考，不直接复用其内部 definition/path/override 接口。

## 当前目标

第一阶段只解决一个问题：

> 给定一个明确任务和目标字段，恢复该任务内部的字段生产逻辑。

标准输入：

```text
job_id + schema.table.column
```

标准输出：

```text
column_logic.json
production.sql
```

## 核心依赖分类

新实现只暴露四种业务含义：

1. `value`：真正参与目标字段数值计算；
2. `context`：JOIN、过滤、分组、窗口或计算参数；
3. `rowset`：影响结果行集合，但不直接贡献目标值；
4. `constant_branch`：UNION 分支对目标字段贡献常量。

内部数据库 ID 不作为主要结果展示。

## 开发顺序

- [x] Step 1：独立目录、领域模型、CLI 骨架；
- [x] Step 2：从 PostgreSQL 按 `job_id` 读取原始任务 SQL；
- [x] Step 3：解析 INSERT、定位目标表和目标列；
- [x] Step 4：单任务 AST 反向列切片；
- [x] Step 5：生成 `column_logic.json`；
- [x] Step 6：生成并验证 `production.sql`；
- [x] Step 7：用任务 `100021029.active_cnt` 验收；
- [x] Step 8：增加更多单任务样例与全列兼容性审计；
- [ ] Step 9：按任意分区键实现跨任务 producer 选择；
- [ ] Step 10：项目主体完成后再进行 Neo4j 建模。

每一步完成并确认后，才进入下一步。

## 当前目录

```text
build_lineage/
├── README.md
├── __init__.py
├── __main__.py
├── audit_all_columns.py
├── cli.py
├── column_tracer.py
├── config.py
├── document.py
├── models.py
├── postgres.py
├── production_sql.py
├── sql_parser.py
└── tests/
    ├── __init__.py
    ├── test_models.py
    ├── test_postgres.py
    ├── test_production_sql.py
    └── test_sql_parser.py
```

## 当前可执行命令

查看新实现状态：

```bash
uv run python -m build_lineage status
```

检查 PostgreSQL 连接和 `lineage.job` 数据：

```bash
uv run python -m build_lineage db-check
```

通过 HTTP 元数据服务查看表字段、类型、注释、字段位置和分区信息：

```bash
uv run python -m build_lineage show-table-schema \
  --table mt_dwm.zgame_ltv_day_1
```

接口默认使用
`http://fons-dev.test.bi.moontontech.net/metadata/metadata/tables/by-name`，可通过
`BIRAG_TABLE_METADATA_URL` 覆盖，超时秒数通过 `BIRAG_METADATA_TIMEOUT` 配置。

按业务任务号读取任务（默认不打印可能很长的 SQL）：

```bash
uv run python -m build_lineage show-job --job-id 100021029
```

需要查看完整原始 SQL 时：

```bash
uv run python -m build_lineage show-job \
  --job-id 100021029 \
  --include-sql
```

连接配置从项目根目录 `.env` 读取，支持 `BIRAG_PG_DSN`，也支持
`BIRAG_PG_HOST/PORT/DB/USER/PASSWORD`；schema 使用
`BIRAG_LINEAGE_SCHEMA`，默认 `lineage`。该模块不会调用旧 lineage 代码。

解析任务的 INSERT 结构：

```bash
uv run python -m build_lineage parse-job --job-id 100021029
```

默认结果只展示输出字段名、分区标识、源表和 UNION 分支摘要。需要同时查看
每个输出字段的原始表达式时，增加 `--include-expressions`。

追踪单个任务内目标字段的生产链：

```bash
uv run python -m build_lineage trace-column \
  --job-id 100021029 \
  --column active_cnt
```

结果区分真正贡献数值的物理字段、UNION 常量分支，以及 JOIN、过滤和分组
上下文。默认输出为便于阅读的摘要；需要调试完整递归树时增加
`--include-trace`。当前命令只追踪单个任务内部，不进行跨任务 producer 选择。

生成稳定的单字段逻辑文件：

```bash
uv run python -m build_lineage build-column-logic \
  --job-id 100021029 \
  --column active_cnt
```

默认写入
`build_lineage/output/<job_id>/<column>/column_logic.json`。该输出目录已忽略
生成文件，避免再次把大量派生结果提交到 Git；也可以用 `--output` 指定路径。

生成独立字段生产 SQL：

```bash
uv run python -m build_lineage build-production-sql \
  --job-id 100021029 \
  --column active_cnt
```

默认写入同目录的 `production.sql`。生成器从原始 AST 裁剪投影，保留目标字段
所需的分组粒度、动态分区、JOIN、过滤、CTE 和 UNION 分支。写入前执行 AST
重解析、派生查询输出契约和字段值来源一致性检查；这属于静态验证，不代表已在
Hive 集群实际运行。

如果最终 INSERT 投影是 `SUM(login_cnt)` 这类没有显式别名的表达式，工具会在
按输出名查找失败后查询目标表元数据，按非分区字段位置映射目标字段。映射前会
严格校验 INSERT 数据列数与目标表非分区字段数一致；只在内存 AST 中补充别名，
不会修改原始任务 SQL。

## 全列兼容性审计

先对少量任务冒烟检查：

```bash
uv run python -m build_lineage audit-production-sql \
  --job-id 100021029 \
  --job-id 100039142 \
  --job-id 100030100 \
  --report-dir build_lineage/audit_runs/smoke
```

全量扫描 PostgreSQL `lineage.job`：

```bash
uv run python -m build_lineage audit-production-sql \
  --all-jobs \
  --progress-every 100
```

建议先限制规模观察速度和错误类型：

```bash
uv run python -m build_lineage audit-production-sql \
  --all-jobs \
  --limit 20 \
  --max-columns-per-job 5
```

默认只在内存中生成并验证 SQL，避免落盘数万份派生文件。增加 `--write-sql`
才会保存每个成功列的 `production.sql`。每次运行生成：

- `summary.json`：总任务、表、列、成功率；
- `failures.jsonl`：每个问题列的任务、表、字段、阶段和错误；
- `failure_groups.json`：按兼容问题类型聚合，并保留样例；
- `tables.json`：按目标表汇总任务和列结果；
- `successes.jsonl`：成功列及值来源。

`audit_runs` 已加入忽略规则，不会把批量派生报告提交到 Git。
