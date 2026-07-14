# mt_ads_realtime.ads_realtime_netinfoping_detail_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_netinfoping_detail_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH netinfoping_cnt AS( SELECT point, COUNT(DISTINCT accountid) AS cnt FROM( SELECT logymd, appname, granularity_type, date_type, accountid, zoneid, big_zoneid, country, operator, province, errortype, point FROM mt_ads_realtime.ads_realtime_netinfoping_detail_di) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${big_zoneid} AND ${zoneid} AND ${region} AND ${country} AND ${operator} AND ${province} AND ${errortype} and errortype in (811, 812, 711, 712) GROUP BY point ), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) AS max_point ) SELECT '#{data_date}' AS logymd, l.point, l.cnt AS point_cnt FROM netinfoping_cnt l CROSS JOIN max_point_cte m WHERE l.point <= m.max_point
```