# mt_ads_realtime.realtime_online_cube_view_us_test  ()

> 

- 物理表: `mt_ads_realtime.realtime_online_cube_view_us_test` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[acu]], [[pcu]], [[register_reten_cnt_2]], [[register_reten_cnt_2_total]], [[register_reten_cnt_7]], [[register_reten_cnt_7_total]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[acu]], [[num]], [[num_7]], [[pcu]], [[register_reten_cnt_2_total]], [[register_reten_cnt_7_total]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT MAX(online_num) AS online_num, MAX(online_num) AS pcu, SUM(online_num) / (MAX(point) + 1) AS acu FROM mt_ads_realtime.realtime_online_cube_view_us_test WHERE point <= ( SELECT IF( ${IS_USE_CURRENT_POINT}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) ) AND ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${definition_type} AND ${grouping_name}
```