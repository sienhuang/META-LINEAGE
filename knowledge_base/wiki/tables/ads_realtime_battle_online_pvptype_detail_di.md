# mt_ads_realtime.ads_realtime_battle_online_pvptype_detail_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_battle_online_pvptype_detail_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH base_data AS( SELECT logymd, point, date_type, appname, granularity_type, user_online_num FROM mt_ads_realtime.ads_realtime_battle_online_pvptype_detail_di WHERE battle_group not in(55, 56, 57) and ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${big_zoneid} and ${zoneid} and ${os} and ${region} and ${country} and ${channel} and ${realpvptype} and ${battle_svrid} and ${battle_group}), battle_online_cnt AS( SELECT point, sum(user_online_num) AS point_cnt FROM base_data GROUP BY point), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00'))) / 300 ), 512 ) AS max_point ) SELECT '#{data_date}' AS logymd, b.point, b.point_cnt FROM battle_online_cnt b CROSS JOIN max_point_cte m WHERE b.point <= m.max_point ORDER BY b.point ASC
```