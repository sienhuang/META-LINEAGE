# mt_ads_realtime.realtime_basic_create_role_retention  ()

> 

- 物理表: `mt_ads_realtime.realtime_basic_create_role_retention` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[create_role_day_cnt]], [[create_role_day_cnt_7d]], [[login_day_cnt]], [[login_day_cnt_7d]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[create_role_day_cnt]], [[create_role_day_cnt_7d]], [[num]], [[num_7]], [[value]], [[value_7]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, region, country, channel, MAX(retention_cnt_arr[1]) AS login_day_cnt, MAX(IF(retention_cnt_arr[1] IS NULL, 0, register_cnt_arr[1])) AS create_role_day_cnt, MAX(retention_cnt_arr[2]) AS login_day_cnt_3d, MAX(IF(retention_cnt_arr[2] IS NULL, 0, register_cnt_arr[2])) AS create_role_day_cnt_3d, MAX(retention_cnt_arr[6]) AS login_day_cnt_7d, MAX(IF(retention_cnt_arr[6] IS NULL, 0, register_cnt_arr[6])) AS create_role_day_cnt_7d, MAX(retention_cnt_arr[29]) AS login_day_cnt_30d, MAX(IF(retention_cnt_arr[29] IS NULL, 0, register_cnt_arr[29])) AS create_role_day_cnt_30d FROM mt_ads_realtime.realtime_basic_create_role_retention a LEFT JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${channel} AND point <= ( SELECT IF( ${IS_USE_CURRENT_POINT}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) ) GROUP BY logymd, region, country, channel
```