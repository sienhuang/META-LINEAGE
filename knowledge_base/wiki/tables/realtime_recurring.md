# mt_ads_realtime.realtime_recurring  ()

> 

- 物理表: `mt_ads_realtime.realtime_recurring` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- MAP 列里: [[avg_active_cnt]], [[mau]]  (取数 `indicator_map['x']`)
- 直接列: [[day_cnt]], [[point_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[MAU]], [[bar_value]], [[value]], [[月均活跃度]], [[月日均DAU]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select country, region, max(day_cnt) as day_cnt from (select granularity_type,date_type,appname,logymd,point,country,network,point_cnt,day_cnt from mt_ads_realtime.realtime_recurring)  a  left outer join ( select region, country_type ,definition_type , country_code from mt_dim.dim_country where ${definition_type} ) b on a.country = b.country_code where point <= (SELECT if(${IS_USE_CURRENT_POINT} , floor((hour(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))* 3600 + minute(CONVERT_TZ(now(),@@system_time_zone, '-08:00'))* 60 + second(CONVERT_TZ(now(), @@system_time_zone, '-08:00')))/ 300), 512)) and ${logymd} and ${appname} and ${granularity_type} and ${date_type}  and ${country} and ${region} group by country, region
```