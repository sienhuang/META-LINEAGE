# hive.mt_ads  ()

> 

- 物理表: `hive.mt_ads` · 引擎: doris/sr · 分层: None · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH point_range AS( SELECT generate_series AS point FROM TABLE(generate_series(0, 287))), online_cnt AS( SELECT point, sum(online_num) AS cnt FROM( select logymd, zoneid, big_zoneid, country, os, point, date_type, appname, granularity_type, online_num, grouping_name from hive.mt_ads.ads_decismart_realtime_zone_online) a left outer join ( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and grouping_name = 'country' and ${big_zoneid} and ${zoneid} and ${os} and ${region} and ${country} and ${channel} GROUP BY point), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00'))) / 300), 512) AS max_point ) SELECT '#{data_date}' as logymd, r.point, l.cnt AS point_cnt, SUM(COALESCE(l.cnt, 0)) OVER ( ORDER BY r.point ASC) AS day_cnt FROM point_range r LEFT JOIN online_cnt l ON r.point = l.point CROSS JOIN max_point_cte m WHERE r.point <= m.max_point
```