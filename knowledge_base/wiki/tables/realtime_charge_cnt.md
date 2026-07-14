# mt_ads_realtime.realtime_charge_cnt  ()

> 

- 物理表: `mt_ads_realtime.realtime_charge_cnt` · 引擎: flink/realtime · 分层: None · 粒度: — · 类型: wide_table

> ⚠️ 实时表:口径在 Flink 任务,列级血缘暂未解析(待补)。

## 包含的底层指标
- 直接列: [[active_cnt]], [[pay_amt]], [[pay_cnt]], [[point_pay_amt]], [[point_pay_cnt]], [[register_reten_cnt_1]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[ARPPU]], [[active_cnt]], [[arppu]], [[bar_value]], [[pay_cnt]], [[value]], [[付费率]], [[付费玩家数]], [[区域]], [[新增玩家]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select country, region, max(day_cnt) as pay_cnt from mt_ads_realtime.realtime_charge_cnt a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where point <=( SELECT if(${IS_USE_CURRENT_POINT} , floor((hour(CONVERT_TZ(now(), @@system_time_zone, '-08:00')) * 3600 + minute(CONVERT_TZ(now(), @@system_time_zone, '-08:00'))* 60 + second(CONVERT_TZ(now(), @@system_time_zone, '-08:00')))/ 300), 512)) and ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${country} and ${region} and ${user_type} group by country, region
```