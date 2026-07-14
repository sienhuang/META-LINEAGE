# mt_ads_realtime.realtime_online_cube_view  ()

> 

- 物理表: `mt_ads_realtime.realtime_online_cube_view` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[acu]], [[online_num]], [[pcu]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[acu]], [[bar_value]], [[pcu]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, point, CASE WHEN point = MAX(point) OVER( PARTITION BY logymd ) AND SUM(online_num) = 0 THEN NULL ELSE SUM(online_num) END AS online_num, MAX(pcu) AS pcu, avg(acu) AS acu FROM ( WITH t AS( SELECT logymd, point, country, region, SUM(online_num) AS online_num FROM mt_ads_realtime.realtime_online_cube_view WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${definition_type} AND ${grouping_name} GROUP BY logymd, country, region, point ), t_pcu AS ( SELECT logymd, point, SUM(online_num) AS online_num, MAX(SUM(online_num)) OVER ( PARTITION BY logymd ORDER BY point ) AS pcu, AVG(SUM(online_num)) OVER ( PARTITION BY logymd ORDER BY point ) AS acu FROM t GROUP BY logymd, point ), t_incr AS ( SELECT t2.logymd, t2.country, t1.point FROM ( SELECT point FROM mt_dim.dim_point ) t1 CROSS JOIN ( SELECT logymd, country FROM t GROUP BY logymd, country ) t2 ), t_all AS ( SELECT logymd, point, online_num, max_pcu AS pcu, online_num_acu / (point + 1) AS acu FROM ( SELECT *, MAX(pcu) OVER ( PARTITION BY logymd ORDER BY point ) AS max_pcu, SUM(online_num) OVER ( PARTITION BY logymd ORDER BY point ) AS online_num_acu FROM ( SELECT max(COALESCE(t_pcu.logymd, t_incr.logymd)) AS logymd, max(COALESCE(t_pcu.point, t_incr.point)) AS point, max(COALESCE(t_pcu.online_num, NULL)) AS online_num, max(COALESCE(t_pcu.pcu, NULL)) AS pcu FROM t_pcu FULL JOIN t_incr ON t_pcu.logymd = t_incr.logymd AND t_pcu.point = t_incr.point group by t_pcu.point ) t ) t ) SELECT logymd, point, online_num, pcu, acu FROM t_all WHERE point <= ( SELECT IF( ${IS_USE_CURRENT_POINT_EACH}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) ) ORDER BY logymd, point ) AS tmp GROUP BY logymd, point
```