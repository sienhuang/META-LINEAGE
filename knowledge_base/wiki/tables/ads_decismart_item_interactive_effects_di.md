# mt_ads.ads_decismart_item_interactive_effects_di  ()

> 

- 物理表: `mt_ads.ads_decismart_item_interactive_effects_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `country` | derived | UNION_BRANCH_COLUMN[1] |
| `friends_use_item_cnt` | derived | UNION_BRANCH_COLUMN[6] |
| `grouping_name` | derived | UNION_BRANCH_COLUMN[8] |
| `item_id` | derived | UNION_BRANCH_COLUMN[2] |
| `nonfriends_use_item_cnt` | derived | UNION_BRANCH_COLUMN[7] |
| `scene_type` | derived | UNION_BRANCH_COLUMN[3] |
| `use_item_cnt` | derived | UNION_BRANCH_COLUMN[4] |
| `use_user_cnt` | derived | UNION_BRANCH_COLUMN[5] |

## 包含的底层指标
- 直接列: [[item_name]], [[use_item_cnt]], [[use_user_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100053444
- 被这些指标使用: [[item_name]], [[use_item_cnt]], [[use_user_cnt]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH t_filter_item AS ( SELECT item_id, avg(use_user_cnt) AS use_user_cnt FROM ( SELECT logymd, item_id, SUM(use_user_cnt) AS use_user_cnt FROM ( SELECT a.logymd, appname, granularity_type, date_type, a.item_id, country, scene_type, use_item_cnt, use_user_cnt, friends_use_item_cnt, nonfriends_use_item_cnt, grouping_name, item_name, item_quality, funnel_type, distribution_type, distribution_channel FROM mt_ads.ads_decismart_item_interactive_effects_di a LEFT OUTER JOIN ( SELECT item_id, item_name, item_type, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id WHERE b.is_personalization_item = 1 AND b.item_type = 6 ) a WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND grouping_name = '(all)' GROUP BY logymd, item_id ) a GROUP BY item_id HAVING avg(use_user_cnt) > 100 ), t_item_info AS ( SELECT logymd, item_id, MAX(item_name) AS item_name, SUM(use_item_cnt) AS use_item_cnt, SUM(use_user_cnt) AS use_user_cnt, SUM(friends_use_item_cnt) AS friends_use_item_cnt, SUM(nonfriends_use_item_cnt) AS nonfriends_use_item_cnt FROM ( SELECT a.logymd, appname, granularity_type, date_type, a.item_id, country, scene_type, use_item_cnt, use_user_cnt, friends_use_item_cnt, nonfriends_use_item_cnt, grouping_name, item_name, item_quality, funnel_type, distribution_type, distribution_channel FROM mt_ads.ads_decismart_item_interactive_effects_di a LEFT OUTER JOIN ( SELECT item_id, item_name, item_type, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id WHERE b.is_personalization_item = 1 AND b.item_type = 6 ) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${network_group} AND ${pay_grade} AND ${register_dur} AND ${item_quality} AND ${item_id} AND grouping_name = '(all)' GROUP BY logymd, item_id ) SELECT logymd, a.item_id, item_name, use_item_cnt, a.use_user_cnt, friends_use_item_cnt, nonfriends_use_item_cnt FROM t_item_info a INNER JOIN t_filter_item b ON a.item_id = b.item_id
```