# mt_ads_realtime.ads_realtime_match_end_detail_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_match_end_detail_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH match_end_cnt AS( SELECT point, SUM(CASE WHEN pvptype IN(1, 2, 4) AND quit_reason <> 15 THEN success ELSE 0 END) AS success_cnt, count(CASE WHEN pvptype IN (1, 2, 4) AND quit_reason <> 15 THEN 1 ELSE NULL END) AS battle_cnt FROM ( SELECT logymd, appname, granularity_type, date_type, country, pvptype, quit_reason, success, matchid, point FROM mt_ads_realtime.ads_realtime_match_end_detail_di) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${matchid} GROUP BY point ), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) AS max_point ) SELECT '#{data_date}' AS logymd, l.point, success_cnt, battle_cnt FROM match_end_cnt l CROSS JOIN max_point_cte m WHERE l.point <= m.max_point
```