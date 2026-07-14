# test.ads_decismart_rank_analysis  ()

> 

- 物理表: `test.ads_decismart_rank_analysis` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[active_cnt]], [[battle_cnt]], [[his_rank_role_cnt]], [[last_season_rank_role_cnt]], [[ol_dur_age_group_arr]], [[ol_dur_age_group_role_cnt_arr]], [[ol_dur_age_group_role_cnt_arr_total]], [[ol_dur_sex_arr]], [[ol_dur_sex_role_cnt_arr]], [[ol_dur_sex_role_cnt_arr_total]], [[ol_dur_user_type_arr]], [[ol_dur_user_type_role_cnt_arr]], [[ol_dur_user_type_role_cnt_arr_total]], [[online_dur]], [[rank_distribute_role_array]], [[reach_his_bigrank_role_cnt]], [[reach_last_season_bigrank_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[active_cnt]], [[num]], [[ol_dur_age_group_role_cnt_arr]], [[ol_dur_sex_role_cnt_arr]], [[ol_dur_user_type_role_cnt_arr]], [[online_dur_per_person]], [[user_rate]], [[value]], [[人均在线时长]], [[人均场次]], [[历史最高段位达成率]], [[用户类型]], [[社会属性标签]], [[赛季最高段位达成率]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, sum(online_dur) as online_dur, sum(battle_cnt) as battle_cnt, sum(active_cnt) as active_cnt, sum(reach_his_bigrank_role_cnt) as reach_his_bigrank_role_cnt, sum(his_rank_role_cnt) as his_rank_role_cnt, sum(reach_last_season_bigrank_cnt) as reach_last_season_bigrank_cnt, sum(last_season_rank_role_cnt) as last_season_rank_role_cnt from test.ads_decismart_rank_analysis a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and granularity_type = 'role' and ${date_type} and ${country} and zone = 1 and ${region} group by date_range
```