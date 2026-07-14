# test.ads_skin_info_test  ()

> 

- 物理表: `test.ads_skin_info_test` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[active_cnt]], [[resource_array]], [[resource_num]], [[resoure_active_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[人均拥有数]], [[活跃拥有率]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select * from test.ads_skin_info_test a join ( select country_code from test.dim_country_new where ${definition_type} ) b on a.country = b.country_code where ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${pay_level} AND ${register_diff}
```