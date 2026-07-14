# mt_ads_realtime.realtime_basic_login  ()

> 

- 物理表: `mt_ads_realtime.realtime_basic_login` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[active_cnt]], [[active_cnt_kpi]], [[arpu_kpi]], [[day_cnt]], [[pay_amt]], [[pay_amt_daily]], [[pay_amt_kpi]], [[point_active_cnt]], [[point_cnt]], [[point_pay_amt]], [[register_cnt]], [[register_cnt_7d]], [[register_cnt_kpi]], [[register_cnt_yd]], [[register_reten2]], [[register_reten7]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[ARPU]], [[DAU]], [[active_cnt]], [[arpu]], [[bar_value]], [[completion_rate]], [[day_cnt]], [[day_cnt_ratio]], [[num]], [[value]], [[value_7]], [[区域]], [[渠道]], [[渠道(大类)]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, region, country, channel, MAX(day_cnt) AS day_cnt FROM mt_ads_realtime.realtime_basic_login a LEFT JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${appname} AND ${logymd} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${channel} AND point <= ( SELECT IF( ${IS_USE_CURRENT_POINT}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) ) GROUP BY logymd, region, country, channel
```