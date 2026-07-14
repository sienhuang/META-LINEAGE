# mt_ads.ads_decismart_item_info_di  ()

> 

- 物理表: `mt_ads.ads_decismart_item_info_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `country` | direct | tk.country |
| `equip_hero_cnt` | direct | equip_hero_cnt |
| `equip_start_battle_cnt` | direct | equip_start_battle_cnt |
| `equip_user_cnt` | direct | equip_user_cnt |
| `funnel_type` | derived | CASE WHEN item_type IN (4, 6, 11, 13, 14, 15, 16, 17, 18) THEN 1 WHEN item_type IN (1, 2, 3, 5, 7, 8, 12) THEN 2 WHEN it |
| `is_personalization_item` | direct | is_personalization_item |
| `is_release_item` | direct | is_release_item |
| `item_id` | direct | item_id |
| `item_type` | direct | item_type |
| `pay_grade` | direct | tk.pay_grade |
| `unlock_item_cnt` | direct | unlock_item_cnt |
| `unlock_user_cnt` | direct | unlock_user_cnt |
| `use_item_cnt` | direct | use_item_cnt |
| `use_user_cnt` | direct | use_user_cnt |

## 包含的底层指标
- 直接列: [[distribution_type]], [[item_name]], [[unlock_item_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100053443
- 被这些指标使用: [[distribution_type]], [[item_name]], [[unlock_item_cnt]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, item_id, pay_grade, MAX(item_name) AS item_name, MAX(distribution_type) AS distribution_type, SUM(unlock_item_cnt) AS unlock_item_cnt FROM ( SELECT a.logymd, appname, granularity_type, date_type, a.item_id, country, pay_grade, unlock_item_cnt, unlock_user_cnt, equip_user_cnt, use_item_cnt, use_user_cnt, equip_hero_cnt, equip_start_battle_cnt, active_cnt, item_name, item_quality, b.funnel_type, distribution_type, distribution_channel FROM mt_ads.ads_decismart_item_info_di a LEFT OUTER JOIN ( SELECT item_id, item_type, item_name, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id AND a.item_type = b.item_type WHERE a.is_release_item = 1 AND b.is_release_item = 1 ) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${network_group} AND ${pay_grade} AND ${register_dur} AND ${item_quality} AND ${item_id} GROUP BY logymd, item_id, pay_grade
```