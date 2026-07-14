# mt_ads_realtime_pre.realtime_create_role_retention  ()

> 

- 物理表: `mt_ads_realtime_pre.realtime_create_role_retention` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[create_role_day_cnt]], [[create_role_day_cnt_7d]], [[login_day_cnt]], [[login_day_cnt_7d]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[value]], [[value_7]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, country, region, login_day_cnt, create_role_day_cnt, login_day_cnt_7d, create_role_day_cnt_7d, point FROM mt_ads_realtime_pre.realtime_create_role_retention a LEFT JOIN( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type}) b ON a.country = b.country_code WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region}
```