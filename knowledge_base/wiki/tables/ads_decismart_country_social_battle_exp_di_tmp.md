# mt_ads.ads_decismart_country_social_battle_exp_di_tmp  ()

> 

- 物理表: `mt_ads.ads_decismart_country_social_battle_exp_di_tmp` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, heroid, day_hero_app_cnt_total, day_hero_ban_cnt_total, day_hero_app_cnt, day_hero_ban_cnt, day_hero_win_cnt from( select date_range as logymd, array_sum(day_hero_app_cnt_array) as day_hero_app_cnt_total, array_sum(day_hero_ban_cnt_array) as day_hero_ban_cnt_total, ${qffm_heroid_x} from mt_ads.ads_decismart_country_social_battle_exp_di_tmp a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and logymd >= '2024-01-01' and ${appname} and granularity_type = 'role' and ${date_type} and ${country} and zone = 1 and ${region} and ${pvptype} and ${big_ranklevel}) res, unnest(heroid_arr, day_hero_app_cnt_array, day_hero_ban_cnt_array, day_hero_win_cnt_array) as t1(heroid, day_hero_app_cnt, day_hero_ban_cnt, day_hero_win_cnt) where ${heroid}
```