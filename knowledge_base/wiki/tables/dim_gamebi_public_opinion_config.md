# test.dim_gamebi_public_opinion_config  ()

> 

- 物理表: `test.dim_gamebi_public_opinion_config` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select distinct game_name from test.dim_gamebi_public_opinion_config where logymd = (select max(logymd) from test.dim_gamebi_public_opinion_config) and  is_attention = 1
```