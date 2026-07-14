# test.ads_decismart_gamepackage_cube_di  ()

> 

- 物理表: `test.ads_decismart_gamepackage_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[avg_space]], [[mid_space]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[包体75中位数]], [[包体中位数]], [[包体平均数]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, region, country, zone, avg_space, mid_space, 75mid_space from test.ads_decismart_gamepackage_cube_di where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${definition_type} and ${grouping_name} and ${country} and ${region} and ${zone} and ${model_storage} and ${package_grade}
```