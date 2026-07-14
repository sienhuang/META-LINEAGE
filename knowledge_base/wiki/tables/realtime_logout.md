# mt_ads_realtime.realtime_logout  ()

> 

- 物理表: `mt_ads_realtime.realtime_logout` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[active_cnt]], [[online_dur]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[在线时长]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, point, sum(day_cnt) as active_cnt, sum(day_online_time) as online_dur from mt_ads_realtime.realtime_logout a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${user_type} group by logymd, point
```