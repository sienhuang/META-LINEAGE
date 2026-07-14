# mt_ads_realtime.ads_realtime_batch_data_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_batch_data_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[active_cnt]], [[online_num]], [[pay_amt]], [[pay_cnt]], [[point_active_cnt]], [[point_pay_amt]], [[point_pay_cnt]], [[point_register_cnt]], [[register_cnt]], [[register_cnt_yd]], [[register_login_cnt]], [[register_pay_amt]], [[register_pay_cnt]], [[register_reten2]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[DAU]], [[active_cnt]], [[active_cnt_ratio]], [[bar_value]], [[pay_amt]], [[pay_amt_ratio]], [[pay_cnt]], [[pay_cnt_rate]], [[pay_cnt_ratio]], [[register_cnt]], [[register_cnt_ratio]], [[value]], [[付费率]], [[付费玩家数]], [[创号渠道]], [[在线玩家数]], [[收入金额]], [[新增付费率]], [[新增玩家ARPU]], [[新增玩家数]], [[新增玩家次留]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, country, max(IF(event = 'login', day_cnt, NULL)) AS active_cnt, max(IF(event = 'charge', day_cnt, NULL)) AS pay_amt, max(IF(event = 'charge_cnt', day_cnt, NULL)) AS pay_cnt, max(IF(event = 'create', day_cnt, NULL)) AS register_cnt FROM mt_ads_realtime.ads_realtime_batch_data_di a LEFT JOIN( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type}) b ON a.country = b.country_code WHERE ${appname} AND ${logymd} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${user_type} AND point <=( SELECT IF(${IS_USE_CURRENT_POINT}, floor((HOUR(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))) / 300), 512)) GROUP BY logymd, country
```