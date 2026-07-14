# mt_ads_realtime.ads_mlbb_realtime_batch_data_di  ()

> 

- 物理表: `mt_ads_realtime.ads_mlbb_realtime_batch_data_di` · 引擎: flink/realtime · 分层: ads · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[active_cnt]], [[match_fm_day_cnt]], [[match_fz_day_cnt]], [[network_fm_day_cnt]], [[network_fz_day_cnt]], [[pay_amt]], [[register_cnt]], [[register_cnt_7d]], [[register_cnt_yd]], [[register_reten2]], [[register_reten7]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[active_cnt]], [[arpu]], [[num]], [[num_7]], [[register_cnt_7d]], [[register_cnt_yd]], [[匹配成功率]], [[区域]], [[网络满足率]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, point, SUM(IF(event = 'network_fz', point_cnt, NULL)) AS network_fz_day_cnt, SUM(IF(event = 'network_fm', point_cnt, NULL)) AS network_fm_day_cnt, SUM(IF(event = 'match_fz', point_cnt, NULL)) AS match_fz_day_cnt, SUM(IF(event = 'match_fm', point_cnt, NULL)) AS match_fm_day_cnt FROM mt_ads_realtime.ads_mlbb_realtime_batch_data_di a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND zone_type = 1 GROUP BY logymd, point
```