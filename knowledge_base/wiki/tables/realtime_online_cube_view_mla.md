# mt_ads_realtime.realtime_online_cube_view_mla  ()

> 

- 物理表: `mt_ads_realtime.realtime_online_cube_view_mla` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[acu]], [[online_num]], [[pcu]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[acu]], [[bar_value]], [[pcu]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT max(online_num) AS online_num, max(online_num) AS pcu , ROUND(sum(online_num) /(max(point) + 1)) AS acu FROM mt_ads_realtime.realtime_online_cube_view_mla WHERE point <=( SELECT if(${IS_USE_CURRENT_POINT}, floor((hour(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 3600 + minute(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 60 + second(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))) / 300), 512)) AND ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${definition_type} AND ${grouping_name}
```