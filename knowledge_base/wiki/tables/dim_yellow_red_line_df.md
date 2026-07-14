# test.dim_yellow_red_line_df  ()

> 

- 物理表: `test.dim_yellow_red_line_df` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, metric, config_type, config_id, red_line, yellow_line from test.dim_yellow_red_line_df where dt =( select max(dt) from test.dim_yellow_red_line_df) and ${logymd} and ${metric} and ${config_type} and ${config_id} and ${zone}
```