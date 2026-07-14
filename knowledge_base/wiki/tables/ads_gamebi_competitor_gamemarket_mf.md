# test.ads_gamebi_competitor_gamemarket_mf  ()

> 

- 物理表: `test.ads_gamebi_competitor_gamemarket_mf` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
with t_mlbb_top5 as( select 'mlbb' as app_name, 0 as st_order union all( select app_name, ROW_NUMBER() OVER( ORDER BY st_downloads desc) AS st_order from( select app_name, sum(st_downloads) as st_downloads from ( select app_name, country, st_downloads from test.ads_gamebi_competitor_gamemarket_mf WHERE p = 'p' and logymd between '#{base_logymd_start}' and '#{base_logymd_end}' and app_name not in ('mlbb', 'st_gamemarket') and ${country}) a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${region} group by app_name) t limit 5)) select logymd, mlbb_top5.app_name, mlbb_top5.st_order, sum(st_downloads) as st_downloads from ( select app_name, st_order from t_mlbb_top5) mlbb_top5 left outer join ( select logymd, app_name, country, st_downloads from test.ads_gamebi_competitor_gamemarket_mf where p = 'p' and ${logymd} and app_name in ( select app_name from t_mlbb_top5) and ${country}) competitor on mlbb_top5.app_name = competitor.app_name left outer join ( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) dim on competitor.country = dim.country_code where ${region} and logymd is not null group by logymd, mlbb_top5.app_name, mlbb_top5.st_order order by mlbb_top5.st_order
```