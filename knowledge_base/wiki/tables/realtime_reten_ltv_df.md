# mt_ads_realtime.realtime_reten_ltv_df  ()

> 

- 物理表: `mt_ads_realtime.realtime_reten_ltv_df` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT ${DYNAMIC_GROUPBY_DIMS}, sum(register_reten_cnt[1]) AS register_reten_cnt_1, sum(register_reten_cnt[2]) AS register_reten_cnt_2, sum(register_reten_cnt[3]) AS register_reten_cnt_3, sum(register_reten_cnt[4]) AS register_reten_cnt_4, sum(register_reten_cnt[5]) AS register_reten_cnt_5, sum(register_reten_cnt[6]) AS register_reten_cnt_6, sum(register_reten_cnt[7]) AS register_reten_cnt_7, sum(IF(register_reten_cnt[2] IS NULL, 0, register_reten_cnt[1])) AS register_reten_cnt_2_total, sum(IF(register_reten_cnt[3] IS NULL, 0, register_reten_cnt[1])) AS register_reten_cnt_3_total, sum(IF(register_reten_cnt[4] IS NULL, 0, register_reten_cnt[1])) AS register_reten_cnt_4_total, sum(IF(register_reten_cnt[5] IS NULL, 0, register_reten_cnt[1])) AS register_reten_cnt_5_total, sum(IF(register_reten_cnt[6] IS NULL, 0, register_reten_cnt[1])) AS register_reten_cnt_6_total, sum(IF(register_reten_cnt[7] IS NULL, 0, register_reten_cnt[1])) AS register_reten_cnt_7_total FROM mt_ads_realtime.realtime_reten_ltv_df a LEFT OUTER JOIN( SELECT region, country_type , definition_type , country_code FROM mt_dim.dim_country WHERE ${definition_type}) b ON a.country = b.country_code WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${user_type} GROUP BY ${DYNAMIC_GROUPBY_DIMS}
```