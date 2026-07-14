# mt_ads.ads_decismart_online_di  ()

> 

- 物理表: `mt_ads.ads_decismart_online_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `country` | derived | LOWER(IF(TRIM(country) = '' OR TRIM(country) = '-', 'unknown', TRIM(country))) AS country |
| `online_num` | aggregated | SUM(online_num) AS online_num |
| `os` | derived | CASE os_type WHEN 1 THEN 'ios' WHEN 2 THEN 'android' ELSE 'unknown' END AS os |
| `point` | derived | LEAST(287, (HOUR(TIME) * 3600 + MINUTE(TIME) * 60 + SECOND(TIME)) DIV 300) AS point |

## 包含的底层指标
- 直接列: [[acu]], [[pcu]]  (直接取列)

## 血缘
- 上游源表: wefly_ob_ods.t_real_os_country_online
- 由 ETL 构建(task): 100038736
- 被这些指标使用: [[ACU]], [[PCU]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, max(online_num) as pcu, sum(online_num)/ 288 as acu from( select logymd, point, sum(online_num) as online_num from mt_ads.ads_decismart_online_di a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${os} and ${channel} and ${network} and ${user_type} group by logymd, point) as t group by logymd
```