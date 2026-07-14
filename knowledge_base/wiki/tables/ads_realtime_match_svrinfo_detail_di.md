# mt_ads_realtime.ads_realtime_match_svrinfo_detail_di  ()

> 

- 物理表: `mt_ads_realtime.ads_realtime_match_svrinfo_detail_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH base_data AS( SELECT logymd, point, date_type, appname, granularity_type, matchid, matchsuc, playernum FROM mt_ads_realtime.ads_realtime_match_svrinfo_detail_di WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${big_zoneid} and ${zoneid} and ${os} and ${region} and ${country} and ${channel} and matchid <= 50 and ${matchid}), match_cnt AS( select point, sum(num) as point_cnt from( select point, max(matchsuc) as num from base_data group by point, matchid) as a group by point), max_point_cte AS ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, FLOOR( ( HOUR(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00'))) / 300), 512 ) AS max_point ) SELECT '#{data_date}' as logymd, l.point, l.point_cnt point_cnt FROM match_cnt l CROSS JOIN max_point_cte m WHERE l.point <= m.max_point ORDER BY l.point ASC
```