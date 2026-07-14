# mt_ads_pre.ads_decismart_reten_ltv_df  ()

> 

- 物理表: `mt_ads_pre.ads_decismart_reten_ltv_df` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `appname` | direct | appname |
| `country` | direct | country |
| `date_range` | direct | register_date AS date_range |
| `retention_arr` | derived | CAST(ARRAY_MERGE(CAST(retention_arr AS ARRAY<BIGINT>)) AS ARRAY<BIGINT>) AS retention_arr |

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100048735
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, region, country, os, channel, install_label, network_group, new_type, register_reten_cnt[1] as register_cnt, if(register_reten_cnt[2] is null, 0, register_reten_cnt[1]) as register_reten_cnt_2_total, if(register_reten_cnt[7] is null, 0, register_reten_cnt[1]) as register_reten_cnt_7_total, if(register_reten_cnt[14] is null, 0, register_reten_cnt[1]) as register_reten_cnt_14_total, if(register_reten_cnt[30] is null, 0, register_reten_cnt[1]) as register_reten_cnt_30_total, register_reten_cnt[2] as register_reten_cnt_2, register_reten_cnt[7] as register_reten_cnt_7, register_reten_cnt[14] as register_reten_cnt_14, register_reten_cnt[30] as register_reten_cnt_30, if(pure_reten_cnt[2] is null, 0, pure_reten_cnt[1]) as pure_reten_cnt_2_total, if(pure_reten_cnt[7] is null, 0, pure_reten_cnt[1]) as pure_reten_cnt_7_total, if(pure_reten_cnt[14] is null, 0, pure_reten_cnt[1]) as pure_reten_cnt_14_total, if(pure_reten_cnt[30] is null, 0, pure_reten_cnt[1]) as pure_reten_cnt_30_total, pure_reten_cnt[2] as pure_reten_cnt_2, pure_reten_cnt[7] as pure_reten_cnt_7, pure_reten_cnt[14] as pure_reten_cnt_14, pure_reten_cnt[30] as pure_reten_cnt_30, if(register_charge_amt[2] is null, 0, register_reten_cnt[1]) as register_charge_amt_2_total, if(register_charge_amt[7] is null, 0, register_reten_cnt[1]) as register_charge_amt_7_total, if(register_charge_amt[30] is null, 0, register_reten_cnt[1]) as register_charge_amt_30_total, register_charge_amt[2] as register_charge_amt_2, register_charge_amt[7] as register_charge_amt_7, register_charge_amt[30] as register_charge_amt_30 from mt_ads_pre.ads_decismart_reten_ltv_df a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where dt =( select max(dt) from mt_ads_pre.ads_decismart_reten_ltv_df where ${appname}) and ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${network_group} and ${new_type} and ${install_label} and ${os} and ${channel}
```