# mt_ads.ads_decismart_active_di  ()

> 

- 物理表: `mt_ads.ads_decismart_active_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `active_label` | derived | COALESCE(los.active_label, -99999) AS active_label |
| `age_group` | derived | COALESCE(attr.age_group, -99999) AS age_group |
| `country` | derived | COALESCE(bas.country, 'unknown') AS country |
| `network_group` | derived | COALESCE(bas.network_group, -99999) AS network_group |

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100025289
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, region, country, active_lable, age_group, active_cnt from mt_ads.ads_decismart_active_di a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where definition_type = '0') b on a.country = b.country_code where ${logymd} and appname = 'mlbb' and granularity_type = 'account' and date_type = 'daily' and age_group != -99999 and ${active_lable} and ${age_group} and ${country}
```