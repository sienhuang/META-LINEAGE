# mt_ads.ads_decismart_primary_channel_di  ()

> 

- 物理表: `mt_ads.ads_decismart_primary_channel_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `active_cnt` | direct | active_cnt /*	活跃玩家数 */ |
| `channel` | direct | channel /*	创角平台 */ |
| `country` | direct | country /*	国家 */ |
| `date_range` | direct | date_range /*	日期区间 */ |
| `logymd` | direct | logymd |
| `pay_amt` | direct | pay_amt /*	付费金额(美分) */ |
| `pure_reten_cnt` | derived | CASE WHEN DATEDIFF('2026-05-31', logymd) = 0 THEN SUBARRAY(pure_reten_cnt, 0, 1) WHEN DATEDIFF('2026-05-31', logymd) = 1 |
| `recurring_cnt_30days` | direct | recurring_cnt_30days |
| `register_cnt` | direct | register_cnt /*	新增玩家数 */ |

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100042925
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, sum(register_cnt) as register_cnt, sum(active_cnt) as active_cnt, sum(pay_amt) as pay_amt, sum(recurring_cnt_30days) as recurring_cnt_30days from mt_ads.ads_decismart_primary_channel_di a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${channel} group by date_range
```