# mt_ads_realtime.realtime_basic_online  ()

> 

- 物理表: `mt_ads_realtime.realtime_basic_online` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[acu]], [[consume_amt]], [[online_num]], [[pcu]], [[total_actual_amt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[acu]], [[bar_value]], [[completion_rate]], [[num]], [[pcu]], [[渠道(大类)]], [[累计实收ROI]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT MAX(online_num) AS online_num, MAX(online_num) AS pcu, SUM(online_num) / (MAX(point) + 1) AS acu FROM ( SELECT logymd, point, SUM(online_num) AS online_num FROM mt_ads_realtime.realtime_basic_online a LEFT JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE point <= ( SELECT IF( ${IS_USE_CURRENT_POINT}, floor( ( hour(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 3600 + MINUTE(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) * 60 + SECOND(CONVERT_TZ(NOW(), @@system_time_zone, '-08:00')) ) / 300 ), 512 ) ) AND ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${channel} GROUP BY logymd, point ) t
```