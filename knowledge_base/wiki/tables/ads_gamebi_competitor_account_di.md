# mt_ads.ads_gamebi_competitor_account_di  ()

> 

- 物理表: `mt_ads.ads_gamebi_competitor_account_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `app_name` | direct | tb1.app_name |
| `app_type` | direct | tb1.app_type |
| `battle_level_range` | direct | tb1.battle_level_range |
| `compet_act_cnt` | derived | COALESCE(tb1.compet_act_cnt, 0) AS compet_act_cnt |
| `compet_day_login_duration` | derived | COALESCE(tb1.compet_day_login_duration, 0) AS compet_day_login_duration |
| `day_last_bigranklvl` | direct | tb1.day_last_bigranklvl |
| `first_mt_country` | direct | tb1.first_mt_country |
| `logymd` | direct | tb1.logymd |
| `mlbb_act_cnt` | derived | COALESCE(tb2.compet_act_cnt, 0) AS mlbb_act_cnt |
| `player_type` | direct | tb1.player_type |
| `reten_cnt_2days` | derived | IF(tb1.logymd IN ('2026-05-31'), NULL, COALESCE(tb1.reten_cnt_2days, 0)) AS reten_cnt_2days |
| `reten_cnt_30days` | derived | IF(tb1.logymd IN ('2026-05-31', '2026-05-30', '2026-05-25'), NULL, COALESCE(tb1.reten_cnt_30days, 0)) AS reten_cnt_30day |
| `reten_cnt_7days` | derived | IF(tb1.logymd IN ('2026-05-31', '2026-05-30'), NULL, COALESCE(tb1.reten_cnt_7days, 0)) AS reten_cnt_7days |

## 包含的底层指标
- 直接列: [[compet_act_cnt]], [[compet_day_login_duration]], [[compet_reten_cnt_2days]], [[compet_reten_cnt_30days]], [[compet_reten_cnt_7days]], [[mlbb_act_cnt]], [[mlbb_day_login_duration]], [[mlbb_reten_cnt_2days]], [[mlbb_reten_cnt_30days]], [[mlbb_reten_cnt_7days]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100024326
- 被这些指标使用: [[compet_value]], [[mlbb_value]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT CASE WHEN ds0.logymd IS NOT NULL THEN ds0.logymd WHEN ds1.logymd IS NOT NULL THEN ds1.logymd END AS logymd, ds0.compet_appname, compet_act_cnt, compet_day_login_duration, compet_reten_cnt_2days, compet_reten_cnt_7days, compet_reten_cnt_30days, mlbb_act_cnt, mlbb_act_cnt_android, mlbb_day_login_duration, mlbb_reten_cnt_2days, mlbb_reten_cnt_7days, mlbb_reten_cnt_30days FROM ( SELECT logymd, compet_appname, SUM(compet_act_cnt) AS compet_act_cnt, SUM(compet_day_login_duration) AS compet_day_login_duration, SUM(reten_cnt_2days) AS compet_reten_cnt_2days, SUM(reten_cnt_7days) AS compet_reten_cnt_7days, SUM(reten_cnt_30days) AS compet_reten_cnt_30days FROM mt_ads.ads_gamebi_competitor_account_di a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${compet_appname} AND ${player_type} AND ${country} AND ${region} AND ${battle_level_range} AND ${day_last_bigranklvl} AND ${age_group} GROUP BY logymd, compet_appname ) ds0 FULL JOIN ( SELECT logymd, SUM(compet_act_cnt) AS mlbb_act_cnt, SUM(mlbb_act_cnt_android) as mlbb_act_cnt_android, SUM(compet_day_login_duration) AS mlbb_day_login_duration, SUM(reten_cnt_2days) AS mlbb_reten_cnt_2days, SUM(reten_cnt_7days) AS mlbb_reten_cnt_7days, SUM(reten_cnt_30days) AS mlbb_reten_cnt_30days FROM mt_ads.ads_gamebi_competitor_account_di a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND compet_appname = '大盘' AND ${player_type} AND ${country} AND ${region} AND ${battle_level_range} AND ${day_last_bigranklvl} AND ${age_group} GROUP BY logymd ) ds1 ON ds0.logymd = ds1.logymd
```