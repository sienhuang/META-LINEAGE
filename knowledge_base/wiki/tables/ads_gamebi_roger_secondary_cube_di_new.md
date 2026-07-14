# mt_ads.ads_gamebi_roger_secondary_cube_di_new  ()

> 

- 物理表: `mt_ads.ads_gamebi_roger_secondary_cube_di_new` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, region, country, indicator_map from mt_ads.ads_gamebi_roger_secondary_cube_di_new where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${definition_type} and ${grouping_name}
```