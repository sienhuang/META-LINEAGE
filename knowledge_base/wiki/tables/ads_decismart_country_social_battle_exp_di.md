# test.ads_decismart_country_social_battle_exp_di  ()

> 

- 物理表: `test.ads_decismart_country_social_battle_exp_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[day_battle_cnt_age]], [[day_battle_cnt_sex]], [[day_battle_cnt_total]], [[day_battle_dur_cnt_fm]], [[day_battle_dur_cnt_fm_0]], [[day_battle_dur_cnt_fm_1]], [[day_battle_dur_cnt_fm_2]], [[day_battle_dur_cnt_fm_3]], [[day_battle_dur_cnt_fm_4]], [[day_battle_dur_cnt_fm_5]], [[day_battle_dur_cnt_fm_6]], [[day_battle_dur_cnt_fm_7]], [[day_battle_dur_fz]], [[day_battle_dur_fz_0]], [[day_battle_dur_fz_1]], [[day_battle_dur_fz_2]], [[day_battle_dur_fz_3]], [[day_battle_dur_fz_4]], [[day_battle_dur_fz_5]], [[day_battle_dur_fz_6]], [[day_battle_dur_fz_7]], [[day_black_cnt_age]], [[day_black_cnt_age_total]], [[day_black_cnt_sex]], [[day_black_cnt_sex_total]], [[day_black_type_cnt]], [[day_black_type_cnt_total]], [[day_hero_app_cnt]], [[day_hero_app_cnt_total]], [[day_hero_ban_cnt]], [[day_hero_ban_cnt_total]], [[day_hero_win_cnt]], [[match_exp_match_num]], [[match_exp_match_num_total]], [[match_exp_matchid_socre]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[cnt_rate]], [[day_battle_cnt_age]], [[day_battle_cnt_sex]], [[day_battle_cnt_total]], [[day_black_per_round_rate]], [[hero_app_rate]], [[hero_ban_rate]], [[hero_win_rate]], [[match_exp_match_num]], [[match_exp_matchid_avg_score]], [[rate]], [[传奇]], [[出场率]], [[勇士]], [[史诗]], [[大师]], [[宗师]], [[对局时长]], [[开黑类型]], [[无段位]], [[服务器]], [[社会属性标签]], [[神话]], [[禁用率]], [[精英]], [[胜率]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, black_battle_type, day_battle_cnt_total, day_black_type_cnt_total, t1.day_black_type_cnt from( select date_range as logymd, day_battle_cnt_country_fm as day_battle_cnt_total, array_sum(day_black_type_cnt_array) as day_black_type_cnt_total, ${qffm_black_battle_type_x} from test.ads_decismart_country_social_battle_exp_di a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and granularity_type = 'role' and ${date_type} and ${country} and zone = 1 and ${region}) res, unnest(black_battle_type_arr, day_black_type_cnt_array) as t1(black_battle_type, day_black_type_cnt) where ${black_battle_type}
```