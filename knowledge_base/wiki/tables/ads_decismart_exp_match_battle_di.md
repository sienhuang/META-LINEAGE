# mt_ads.ads_decismart_exp_match_battle_di  ()

> 

- 物理表: `mt_ads.ads_decismart_exp_match_battle_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `battle_complaint_violation_cnt` | direct | battle_complaint_violation_cnt |
| `battle_judge_abuse_succ_cnt` | direct | battle_judge_abuse_succ_cnt |
| `battle_judge_violation_succ_cnt` | direct | battle_judge_violation_succ_cnt |
| `battle_report_abuse_cnt` | direct | battle_report_abuse_cnt |
| `battle_report_violation_cnt` | direct | battle_report_violation_cnt |
| `battle_success_fz` | direct | battle_success_fz |
| `battle_warmcnt_fz` | direct | battle_warmcnt_fz |
| `battlecnt_match_time_fm` | direct | battlecnt_match_time_fm |
| `battlecnt_match_time_fm_origin` | direct | battlecnt_match_time_fm_origin |
| `country` | direct | country |
| `day_battle_cnt_surr_fm` | direct | day_battle_cnt_surr_fm |
| `deep_ai_rollback_fm` | direct | deep_ai_rollback_fm |
| `deep_ai_rollback_fz` | direct | deep_ai_rollback_fz |
| `forbidden_fm` | direct | forbidden_fm |
| `forbidden_fz` | direct | forbidden_fz |
| `leading_game_cnt_fm` | direct | leading_game_cnt_fm |
| `match_success_fm` | direct | match_success_fm |
| `matchid` | direct | matchid |
| `myth_user_cnt_fz` | direct | myth_user_cnt_fz |
| `myth_user_cnt_total_fm` | direct | myth_user_cnt_total_fm |
| `not_dominating_cnt_fz` | direct | not_dominating_cnt_fz |
| `pvptype` | direct | pvptype |
| `road_good_fm` | direct | road_good_fm |
| `road_good_fz` | direct | road_good_fz |
| `successcnt_match_time_fm` | direct | successcnt_match_time_fm |
| `total_battle_cnt_warm_fm` | direct | total_battle_cnt_warm_fm |
| `totalmatchtime_match_time_fm` | direct | totalmatchtime_match_time_fm |
| `win_achieve_fm` | direct | win_achieve_fm |
| `win_achieve_fz` | direct | win_achieve_fz |
| `zone` | direct | zone |

## 包含的底层指标
- 直接列: [[battle_warmcnt_fz]], [[battlecnt_match_time_fm]], [[deep_ai_rollback_fm]], [[deep_ai_rollback_fz]], [[forbidden_fm]], [[forbidden_fz]], [[leading_game_cnt_fm]], [[not_dominating_cnt_fz]], [[road_good_fm]], [[road_good_fz]], [[successcnt_match_time_fm]], [[total_battle_cnt_warm_fm]], [[totalmatchtime_match_time_fm]], [[win_achieve_fm]], [[win_achieve_fz]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100044544, 100044700
- 被这些指标使用: [[分路好局率]], [[匹配成功率]], [[匹配时长]], [[平衡局占比]], [[深度AI回退率]], [[温暖关投放率]], [[禁赛率]], [[胜负达成率]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, region, country, successcnt_match_time_fm, battlecnt_match_time_fm, myth_user_cnt_fz, myth_user_cnt_total_fm, totalmatchtime_match_time_fm, battlecnt_match_time_fm_origin, not_dominating_cnt_fz, leading_game_cnt_fm, battle_success_fz, match_success_fm, battle_warmcnt_fz, total_battle_cnt_warm_fm, win_achieve_fz, win_achieve_fm, road_good_fz, road_good_fm, deep_ai_rollback_fz, deep_ai_rollback_fm, battle_report_abuse_cnt, day_battle_cnt_surr_fm, battle_judge_abuse_succ_cnt, battle_report_violation_cnt, battle_judge_violation_succ_cnt, battle_complaint_violation_cnt, forbidden_fz, forbidden_fm from mt_ads.ads_decismart_exp_match_battle_di a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and granularity_type = 'role' and zone = '1' and ${date_type} and ${country} and ${region} and ${pvptype} and ${matchid}
```