# test.dim_gamebi_hero_config  ()

> 

- 物理表: `test.dim_gamebi_hero_config` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select concat("[", heroid, ",'total'] as heroid_arr,[", day_hero_app_cnt_array, ",array_sum(day_hero_app_cnt_array)] as day_hero_app_cnt_array,[", day_hero_ban_cnt_array, ",array_sum(day_hero_ban_cnt_array)] as day_hero_ban_cnt_array,[", day_hero_win_cnt_array, ",array_sum(day_hero_win_cnt_array)] as day_hero_win_cnt_array") from( select group_concat(concat("'", heroid), "'") as heroid, group_concat(concat("day_hero_app_cnt_array[" , hero_order, "]")) as day_hero_app_cnt_array, group_concat(concat("day_hero_ban_cnt_array[" , hero_order, "]")) as day_hero_ban_cnt_array, group_concat(concat("day_hero_win_cnt_array[" , hero_order, "]")) as day_hero_win_cnt_array from test.dim_gamebi_hero_config) tempView
```