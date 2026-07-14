# hive.mt_dwd  ()

> 

- 物理表: `hive.mt_dwd` · 引擎: doris/sr · 分层: None · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH login_cnt AS( SELECT point, COUNT(DISTINCT roleid) AS point_cnt FROM hive.mt_dwd.dwd_decismart_realtime_login_detail a LEFT OUTER JOIN( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type}) b ON a.country = b.country_code WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${big_zoneid} and ${zoneid} and ${os} and ${channel} and ${country} and ${region} GROUP BY point), max_point_cte AS( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00'))) / 300), 512 ) AS max_point ) SELECT '#{data_date}' AS logymd, b.point, b.point_cnt FROM login_cnt b CROSS JOIN max_point_cte m WHERE b.point <= m.max_point ORDER BY b.point ASC
```