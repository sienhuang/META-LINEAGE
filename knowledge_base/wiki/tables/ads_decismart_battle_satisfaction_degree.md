# test.ads_decismart_battle_satisfaction_degree  ()

> 

- 物理表: `test.ads_decismart_battle_satisfaction_degree` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[meas_value]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[分国家数据]], [[战场满意度]], [[模块]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
%{"season".equals(#dateType) ? "select meas_value from( select *, ROW_NUMBER() OVER ( ORDER BY logymd DESC) AS rnum from ( select logymd, appname, date_type, data_type, meas_value from ( select logymd as data_range, appname, date_type, data_type, meas_value from test.ads_decismart_battle_satisfaction_degree a where dt = ( select max(dt) from test.ads_decismart_battle_satisfaction_degree) and ${appname} and ${date_type} and ${country} and data_type = '#{data_type}') a left outer join( select season_id, seanson_name, left(season_starttime, 10) as logymd from test.dim_gamebi_season_config) b on a.data_range = b.season_id where ${logymd}) t1) rkk where rnum = 1" : "select meas_value from( select *, ROW_NUMBER() OVER ( ORDER BY logymd DESC) AS rnk from test.ads_decismart_battle_satisfaction_degree where dt = ( select max(dt) from test.ads_decismart_battle_satisfaction_degree) and ${logymd} and ${appname} and ${date_type} and ${country} and data_type = '#{data_type}') rkk where rnk = 1"}
```