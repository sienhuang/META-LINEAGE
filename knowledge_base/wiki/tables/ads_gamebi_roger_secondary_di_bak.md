# mt_ads_pre.ads_gamebi_roger_secondary_di_bak  ()

> 

- 物理表: `mt_ads_pre.ads_gamebi_roger_secondary_di_bak` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, country, region, indicator_map from mt_ads_pre.ads_gamebi_roger_secondary_di_bak a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${network_group} and ${new_type} and ${install_label} and ${os} and ${channel}
```