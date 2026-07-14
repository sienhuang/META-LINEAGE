# mt_ads_realtime.realtime_online  ()

> 

- 物理表: `mt_ads_realtime.realtime_online` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select * from mt_ads_realtime.realtime_online where ${logymd} limit 10
```