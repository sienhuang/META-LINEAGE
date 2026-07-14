# test.ads_decismart_new_recall_battle_funnel  ()

> 

- 物理表: `test.ads_decismart_new_recall_battle_funnel` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[new_user_battle_cnt]], [[new_user_battle_cnt_pre]], [[recall_user_battle_cnt]], [[recall_user_battle_cnt_pre]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[percent]], [[value]], [[玩家数]], [[转化率]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select logymd, new_user_battle_funnel, t1.new_user_battle_cnt, t1.new_user_battle_cnt_pre, CAST(t1.config_order AS INT) AS config_order from( select logymd, ${qffm_new_user_battle_funnel_x} from test.ads_decismart_new_recall_battle_funnel a left outer join( select region, country_type , definition_type , country_code from test.dim_country_new where ${definition_type}) b on a.country = b.country_code where ${logymd} and ${appname} and granularity_type = 'role' and ${date_type} and ${country} and zone = 1 and ${region}) res, unnest(new_user_battle_funnel_arr, config_order_arr, new_user_battle_cnt_array, new_user_battle_cnt_pre_array) as t1(new_user_battle_funnel, config_order, new_user_battle_cnt, new_user_battle_cnt_pre) where new_user_battle_funnel != 'unused' and ${new_user_battle_funnel}
```