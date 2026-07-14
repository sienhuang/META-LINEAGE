# test.dim_gamebi_country  ()

> 

- 物理表: `test.dim_gamebi_country` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select * from test.dim_gamebi_country where  ${appname} and ${region} and ${country_code} and ${definition_type}
```