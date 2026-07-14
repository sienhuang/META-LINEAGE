# mt_ads.ads_decismart_primary_cube_di  ()

> 

- 物理表: `mt_ads.ads_decismart_primary_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `active_cnt` | derived | COALESCE(active_cnt, 0) AS active_cnt |
| `country` | derived | COALESCE(country, 'all') AS country |
| `grouping_name` | derived | CONCAT('(', CONCAT_WS(',', IF(NOT country IS NULL, 'country', NULL), IF(NOT pay_grade IS NULL, 'pay_grade', NULL)), ')') |
| `pay_grade` | derived | COALESCE(pay_grade, 'all') AS pay_grade |

## 包含的底层指标
- 直接列: [[active_cnt]], [[distribution_channel]], [[equip_hero_cnt]], [[equip_start_battle_cnt]], [[equip_user_cnt]], [[funnel_type]], [[item_quality]], [[item_type_name]], [[unlock_user_cnt]], [[use_item_cnt]], [[use_user_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100054433
- 被这些指标使用: [[distribution_channel]], [[equip_rate]], [[equip_start_battle_cnt]], [[equip_user_cnt]], [[funnel_type]], [[item_quality]], [[item_type_name]], [[per_equip_hero_cnt]], [[per_equip_start_battle_cnt]], [[unlock_rate]], [[unlock_user_cnt]], [[use_item_cnt]], [[use_rate]], [[use_user_cnt]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH t_active_cnt AS ( SELECT logymd, SUM(active_cnt) AS active_cnt FROM ( SELECT logymd, appname, granularity_type, date_type, date_range, grouping_name, country, pay_grade, active_cnt FROM mt_ads.ads_decismart_primary_cube_di ) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${pay_grade} AND ${grouping_name} GROUP BY logymd ), t_filter_itme_info AS ( SELECT item_id, item_name, item_type, avg(unlock_user_cnt) AS unlock_user_cnt FROM ( SELECT logymd, item_id, item_name, item_type, SUM(unlock_user_cnt) AS unlock_user_cnt FROM ( SELECT a.logymd, a.item_id, b.item_name, b.item_type, unlock_user_cnt FROM mt_ads.ads_decismart_item_info_di a LEFT OUTER JOIN ( SELECT item_id, item_name, item_type, item_type_name, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id AND a.item_type = b.item_type WHERE a.is_personalization_item = 1 AND b.is_personalization_item = 1 AND ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} ) a GROUP BY logymd, item_id, item_name, item_type ) a GROUP BY item_id, item_name, item_type HAVING avg(unlock_user_cnt) > 100 ), t_item_info AS ( SELECT logymd, item_id, item_name, item_type, MAX(item_type_name) AS item_type_name, MAX(item_quality) AS item_quality, MAX(distribution_channel) AS distribution_channel, MAX(funnel_type) AS funnel_type, SUM(unlock_item_cnt) AS unlock_item_cnt, SUM(unlock_user_cnt) AS unlock_user_cnt, SUM(equip_user_cnt) AS equip_user_cnt, SUM(equip_start_battle_cnt) AS equip_start_battle_cnt, SUM(equip_hero_cnt) AS equip_hero_cnt, SUM(use_user_cnt) AS use_user_cnt, SUM(use_item_cnt) AS use_item_cnt FROM ( SELECT a.logymd, appname, granularity_type, date_type, a.item_id, country, pay_grade, unlock_item_cnt, unlock_user_cnt, equip_user_cnt, use_item_cnt, use_user_cnt, equip_hero_cnt, equip_start_battle_cnt, item_name, b.item_type, item_type_name, item_quality, b.funnel_type, distribution_type, distribution_channel FROM mt_ads.ads_decismart_item_info_di a LEFT OUTER JOIN ( SELECT item_id, item_name, item_type, item_type_name, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id AND a.item_type = b.item_type WHERE a.is_personalization_item = 1 AND b.is_personalization_item = 1 AND b.item_type <> 3 AND a.item_type <> 3 ) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${network_group} AND ${pay_grade} AND ${register_dur} AND ${item_quality} AND ${item_id} GROUP BY logymd, item_id, item_name, item_type ) SELECT a.logymd, a.item_id, a.item_name, a.item_type, item_type_name, item_quality, distribution_channel, funnel_type, unlock_item_cnt, a.unlock_user_cnt, equip_user_cnt, equip_start_battle_cnt, equip_hero_cnt, use_user_cnt, use_item_cnt, b.active_cnt FROM t_item_info a INNER JOIN t_filter_itme_info c ON a.item_id = c.item_id AND a.item_name = c.item_name AND a.item_type = c.item_type LEFT JOIN t_active_cnt b ON a.logymd = b.logymd
```