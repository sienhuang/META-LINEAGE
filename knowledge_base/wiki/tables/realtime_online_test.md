# mlbb.realtime_online_test  ()

> 

- 物理表: `mlbb.realtime_online_test` · 引擎: doris/sr · 分层: None · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select point, sum(online_num) as pcu,sum(online_num) as acu from (select granularity_type,date_type,appname,logymd,point,country,dim_type,online_num from mlbb.realtime_online_test) a where online_num != 0 and dim_type = 'all' and ${logymd} and ${appname} and ${granularity_type} and ${date_type} group by point
```