# mt_ads_realtime.realtime_zone_online  ()

> 

- 物理表: `mt_ads_realtime.realtime_zone_online` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[acu]], [[pcu]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[ACU]], [[PCU]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH t AS( SELECT logymd, point, SUM(online_num) AS online_num FROM mt_ads_realtime.realtime_zone_online a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${appname} AND ${logymd} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${zoneid} AND ${user_type} GROUP BY logymd, point), t_pcu AS( SELECT logymd, point, SUM(online_num) AS online_num , MAX(SUM(online_num)) OVER(PARTITION BY logymd ORDER BY point) AS pcu , AVG(SUM(online_num)) OVER(PARTITION BY logymd ORDER BY point) AS acu FROM t GROUP BY logymd, point), t_incr AS( SELECT t2.logymd, t1.point FROM ( SELECT point FROM mt_dim.dim_point) t1 CROSS JOIN ( SELECT logymd FROM t GROUP BY logymd) t2), t_all AS ( SELECT logymd, point, online_num, max_pcu AS pcu , online_num_acu / (point + 1) AS acu FROM ( SELECT *, max(pcu) OVER (PARTITION BY logymd ORDER BY point) AS max_pcu , sum(online_num) OVER (PARTITION BY logymd ORDER BY point) AS online_num_acu FROM ( SELECT COALESCE(t_pcu.logymd, t_incr.logymd) AS logymd , COALESCE(t_pcu.point, t_incr.point) AS point , COALESCE(t_pcu.online_num, 0) AS online_num , COALESCE(t_pcu.pcu, 0) AS pcu FROM t_pcu FULL JOIN t_incr ON t_pcu.logymd = t_incr.logymd AND t_pcu.point = t_incr.point) t) t ) SELECT logymd, point, online_num, pcu, acu FROM t_all WHERE point <= ( SELECT if(${IS_USE_CURRENT_POINT}, floor((hour(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 3600 + minute(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 60 + second(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))) / 300), 512) ) ORDER BY logymd, point
```