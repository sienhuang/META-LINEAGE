# test.dim_gamebi_skin_config  ()

> 

- 物理表: `test.dim_gamebi_skin_config` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select concat("[", heroid, ",'total'] as skinid,[", resource_array, ",sum(resoure_active_cnt)] as skin_active_cnt") from( select group_concat(concat("'", skin_order), "'") as heroid, group_concat(concat("sum(resource_array[" , skin_order, "])")) as resource_array from test.dim_gamebi_skin_config) tempView
```