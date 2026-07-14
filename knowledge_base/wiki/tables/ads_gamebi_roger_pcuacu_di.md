# test.ads_gamebi_roger_pcuacu_di  ()

> 

- 物理表: `test.ads_gamebi_roger_pcuacu_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, region, sum(active_cnt) as active_cnt, sum(recurring_cnt_30days) as recurring_cnt_30days from test.ads_gamebi_roger_pcuacu_di a  left outer join ( select region, country_type ,definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} group by date_range, region
```