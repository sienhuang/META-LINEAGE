# test.ads_decismart_reten_ltv_di  ()

> 

- 物理表: `test.ads_decismart_reten_ltv_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[active_reten_day1]], [[active_reten_day2]], [[active_reten_day30]], [[active_reten_day7]], [[old_reten_day1]], [[old_reten_day2]], [[old_reten_day30]], [[old_reten_day7]], [[pure_reten_day1]], [[pure_reten_day2]], [[pure_reten_day30]], [[pure_reten_day7]], [[recurring_reten_day1]], [[recurring_reten_day2]], [[recurring_reten_day30]], [[recurring_reten_day7]], [[register_charge_day180]], [[register_charge_day30]], [[register_charge_day60]], [[register_charge_day90]], [[register_reten_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[30留]], [[7留]], [[新增LTV_180]], [[新增LTV_30]], [[新增LTV_60]], [[新增LTV_90]], [[次留]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select ${DYNAMIC_GROUPBY_DIMS}, sum(register_reten_cnt[1]) as register_reten_cnt, sum(register_charge_amt[30]) as register_charge_day30, sum(register_charge_amt[31]) as register_charge_day60, sum(register_charge_amt[32]) as register_charge_day90, sum(register_charge_amt[33]) as register_charge_day180, sum(pure_reten_cnt[1]) as pure_reten_day1, sum(pure_reten_cnt[2]) as pure_reten_day2, sum(pure_reten_cnt[7]) as pure_reten_day7, sum(pure_reten_cnt[30]) as pure_reten_day30, sum(old_reten_cnt[1]) as old_reten_day1, sum(old_reten_cnt[2]) as old_reten_day2, sum(old_reten_cnt[7]) as old_reten_day7, sum(old_reten_cnt[30]) as old_reten_day30, sum(active_reten_cnt[1]) as active_reten_day1, sum(active_reten_cnt[2]) as active_reten_day2, sum(active_reten_cnt[7]) as active_reten_day7, sum(active_reten_cnt[30]) as active_reten_day30, sum(recurring_reten_cnt[1]) as recurring_reten_day1, sum(recurring_reten_cnt[2]) as recurring_reten_day2, sum(recurring_reten_cnt[7]) as recurring_reten_day7, sum(recurring_reten_cnt[30]) as recurring_reten_day30 from test.ads_decismart_reten_ltv_di a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${network_group} group by ${DYNAMIC_GROUPBY_DIMS}
```