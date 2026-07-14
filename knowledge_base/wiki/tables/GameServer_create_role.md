# MOBA.GameServer_create_role  ()

> 

- 物理表: `MOBA.GameServer_create_role` · 引擎: doris/sr · 分层: None · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[create_role_day_cnt]], [[login_day_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[昨日新增次留]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, ((hour(time)*3600 + minute(time)*60 + second(time)) div 300) point, count(distinct roleid) num from MOBA.GameServer_create_role where zoneid div 1000 < 57 and ${logymd} and ${curdiamond} group by point, logymd order by point
```