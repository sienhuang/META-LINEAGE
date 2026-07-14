# test.ads_gamebi_roger_secondary_cube_di  ()

> 

- 物理表: `test.ads_gamebi_roger_secondary_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- MAP 列里: [[balance_battle_cnt]], [[balance_cnt]], [[gamepackage_size]], [[gamepackage_size_16g]], [[gamepackage_size_32g]], [[gamepackage_size_64g]], [[gamepackage_size_64g_more]]  (取数 `indicator_map['x']`)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[增量包体大小]], [[存储0～16G手机]], [[存储16～32G手机]], [[存储32～64G手机]], [[存储大于64G手机]], [[平衡局占比]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, region, country, indicator_map from test.ads_gamebi_roger_secondary_cube_di where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${definition_type} and ${grouping_name}
```