# mt_ads_realtime.realtime_point_create_role_retention  ()

> 

- 物理表: `mt_ads_realtime.realtime_point_create_role_retention` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT country, region, max(login_day_cnt) AS login_day_cnt, max(create_role_day_cnt) AS create_role_day_cnt, max(login_day_cnt_7d) AS login_day_cnt_7d, max(create_role_day_cnt_7d) AS create_role_day_cnt_7d FROM mt_ads_realtime.realtime_point_create_role_retention a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${region} AND ${country} AND ${user_type} and point <=( SELECT if(${IS_USE_CURRENT_POINT} , floor((hour(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))* 3600 + minute(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))* 60 + second(CONVERT_TZ(now(), @@system_time_zone, '-08:00')))/ 300), 512)) group by country, region
```