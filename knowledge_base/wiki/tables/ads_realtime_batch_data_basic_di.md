# mt_ads_realtime.ads_realtime_batch_data_basic_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_batch_data_basic_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, region, country, channel, MAX(IF(event = 'active_cnt', day_cnt, NULL)) AS active_cnt, MAX(IF(event = 'pay_amt', day_cnt, NULL)) AS pay_amt, MAX(IF(event = 'pay_cnt', day_cnt, NULL)) AS pay_cnt, MAX(IF(event = 'register_cnt', day_cnt, NULL)) AS register_cnt, MAX(IF(event = 'online_time', day_cnt, NULL)) AS online_time, MAX(IF(event = 'register_reten2', day_cnt, NULL)) AS register_reten2, MAX(IF(event = 'register_cnt_yd', day_cnt, NULL)) AS register_cnt_yd, MAX(IF(event = 'register_reten3', day_cnt, NULL)) AS register_reten3, MAX(IF(event = 'register_cnt_3d', day_cnt, NULL)) AS register_cnt_3d, MAX(IF(event = 'register_reten7', day_cnt, NULL)) AS register_reten7, MAX(IF(event = 'register_cnt_7d', day_cnt, NULL)) AS register_cnt_7d, MAX(IF(event = 'online_num', point_cnt, NULL)) AS pcu, MAX(IF(event = 'online_num', point_cnt, NULL)) AS acu FROM mt_ads_realtime.ads_realtime_batch_data_basic_di a LEFT JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${channel} AND zone_type = 1 AND point <= ( SELECT IF( ${IS_USE_CURRENT_POINT}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '+08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '+08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '+08:00')) ) / 300 ), 512 ) ) GROUP BY logymd, region, country, channel
```