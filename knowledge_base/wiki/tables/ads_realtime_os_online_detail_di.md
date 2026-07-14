# mt_ads_realtime.ads_realtime_os_online_detail_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_os_online_detail_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH point_range AS( SELECT generate_series AS point FROM TABLE(generate_series(0, 287))), online_cnt AS( SELECT point, sum(online_num-vp_online_num) AS cnt FROM( select logymd, zoneid, big_zoneid, os, point, date_type, appname, granularity_type, online_num, vp_online_num from mt_ads_realtime.ads_realtime_os_online_detail_di) a WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${big_zoneid} and ${zoneid} and ${os} and ${channel} GROUP BY point), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00'))) / 300), 512) AS max_point) SELECT '#{data_date}' as logymd, r.point, l.cnt AS point_cnt, SUM(COALESCE(l.cnt, 0)) OVER ( ORDER BY r.point ASC) AS day_cnt FROM point_range r LEFT JOIN online_cnt l ON r.point = l.point CROSS JOIN max_point_cte m WHERE r.point <= m.max_point
```