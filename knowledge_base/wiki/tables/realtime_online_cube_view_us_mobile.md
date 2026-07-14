# mt_ads_realtime.realtime_online_cube_view_us_mobile  ()

> 

- 物理表: `mt_ads_realtime.realtime_online_cube_view_us_mobile` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT point, SUM(online_num) AS online_num, SUM(online_num) AS pcu, SUM(SUM(online_num)) OVER () / (MAX(point) OVER() + 1) AS acu FROM mt_ads_realtime.realtime_online_cube_view_us_mobile WHERE point <= ( SELECT IF( ${IS_USE_CURRENT_POINT}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) ) AND ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND country <> 'us_compliance' AND ${region} AND ${definition_type} AND ${grouping_name} GROUP BY point
```