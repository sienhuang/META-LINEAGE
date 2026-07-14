# test.ads_mlbb_competitor_account_di  ()

> 

- 物理表: `test.ads_mlbb_competitor_account_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select case when ds0.logymd is not null then ds0.logymd when ds1.logymd is not null then ds1.logymd end as logymd, ds0.compet_appname, compet_act_cnt, compet_day_login_duration, compet_reten_cnt_2days, compet_reten_cnt_7days, compet_reten_cnt_30days, mlbb_act_cnt, mlbb_day_login_duration, mlbb_reten_cnt_2days, mlbb_reten_cnt_7days, mlbb_reten_cnt_30days from( select logymd, compet_appname, sum(compet_act_cnt) as compet_act_cnt, sum(compet_day_login_duration) as compet_day_login_duration, sum(reten_cnt_2days) as compet_reten_cnt_2days, sum(reten_cnt_7days) as compet_reten_cnt_7days, sum(reten_cnt_30days) as compet_reten_cnt_30days from test.ads_mlbb_competitor_account_di a left outer join ( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${compet_appname} and ${player_type} and ${country} and ${region} and ${battle_level_range} and ${day_last_bigranklvl} group by logymd, compet_appname) ds0 full join ( select logymd, sum(compet_act_cnt) as mlbb_act_cnt, sum(compet_day_login_duration) as mlbb_day_login_duration, sum(reten_cnt_2days) as mlbb_reten_cnt_2days, sum(reten_cnt_7days) as mlbb_reten_cnt_7days, sum(reten_cnt_30days) as mlbb_reten_cnt_30days from test.ads_mlbb_competitor_account_di a left outer join ( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and compet_appname = '大盘' and ${player_type} and ${country} and ${region} and ${battle_level_range} and ${day_last_bigranklvl} group by logymd) ds1 on ds0.logymd = ds1.logymd
```