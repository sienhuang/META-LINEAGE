# mt_ads_realtime.ads_realtime_create_role_detail_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_create_role_detail_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH point_range AS( SELECT generate_series AS point FROM TABLE(generate_series(0, 287))), dedup_role AS( SELECT roleid, zoneid, big_zoneid, country, os, channel, point, ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY `time` ASC) AS rn FROM mt_ads_realtime.ads_realtime_create_role_detail_di WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type}), filtered_role AS ( SELECT roleid, zoneid, big_zoneid, country, os, channel, point FROM dedup_role WHERE rn = 1 ), filtered_with_dim AS ( SELECT a.point FROM filtered_role a LEFT JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${big_zoneid} AND ${zoneid} AND ${os} AND ${region} AND ${country} AND ${channel} ), login_cnt AS ( SELECT point, SUM(1) AS cnt FROM filtered_with_dim GROUP BY point ), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) AS max_point ) SELECT '#{data_date}' AS logymd, r.point, l.cnt AS point_cnt, SUM(COALESCE(l.cnt, 0)) OVER ( ORDER BY r.point ASC) AS day_cnt FROM point_range r LEFT JOIN login_cnt l ON r.point = l.point CROSS JOIN max_point_cte m WHERE r.point <= m.max_point ORDER BY r.point ASC
```