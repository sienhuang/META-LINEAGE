# test.dim_gamebi_season_config  ()

> 

- 物理表: `test.dim_gamebi_season_config` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select season_id,seanson_name,left(season_starttime,10) as season_starttime from test.dim_gamebi_season_config where season_starttime < curdate() and season_id > 22
```