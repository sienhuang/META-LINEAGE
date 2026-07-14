# mt_ads.ads_decismart_item_gift_di  ()

> 

- 物理表: `mt_ads.ads_decismart_item_gift_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `country` | derived | UNION_BRANCH_COLUMN[1] |
| `entertype` | derived | UNION_BRANCH_COLUMN[3] |
| `gift_hot_val` | derived | UNION_BRANCH_COLUMN[7] |
| `grouping_name` | derived | UNION_BRANCH_COLUMN[6] |
| `item_id` | derived | UNION_BRANCH_COLUMN[2] |
| `send_gift_cnt` | derived | UNION_BRANCH_COLUMN[5] |
| `send_gift_user_cnt` | derived | UNION_BRANCH_COLUMN[4] |

## 包含的底层指标
- 直接列: [[gift_hot_val]], [[item_name]], [[send_gift_cnt]], [[send_gift_user_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100053447
- 被这些指标使用: [[gift_hot_val]], [[item_name]], [[per_send_gift_cnt]], [[send_gift_cnt]], [[send_gift_user_cnt]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH t_filter_item AS ( SELECT item_id, avg(send_gift_user_cnt) AS send_gift_user_cnt FROM ( SELECT logymd, item_id, SUM(send_gift_user_cnt) AS send_gift_user_cnt FROM ( SELECT a.logymd, appname, granularity_type, date_type, a.item_id, country, entertype, send_gift_user_cnt, send_gift_cnt, gift_hot_val, grouping_name, item_name, item_quality, funnel_type, distribution_type, distribution_channel FROM mt_ads.ads_decismart_item_gift_di a LEFT OUTER JOIN ( SELECT item_id, item_name, item_type, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id WHERE b.is_personalization_item = 1 AND b.item_type = 9 ) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND grouping_name = '(all)' GROUP BY logymd, item_id ) a GROUP BY item_id HAVING avg(send_gift_user_cnt) > 100 ), t_item AS ( SELECT logymd, item_id, MAX(item_name) AS item_name, SUM(send_gift_user_cnt) AS send_gift_user_cnt, SUM(send_gift_cnt) AS send_gift_cnt, SUM(gift_hot_val) AS gift_hot_val FROM ( SELECT a.logymd, appname, granularity_type, date_type, a.item_id, country, entertype, send_gift_user_cnt, send_gift_cnt, gift_hot_val, grouping_name, item_name, item_quality, funnel_type, distribution_type, distribution_channel FROM mt_ads.ads_decismart_item_gift_di a LEFT OUTER JOIN ( SELECT item_id, item_name, item_type, item_quality, funnel_type, distribution_type, distribution_channel, is_release_item, is_personalization_item FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_item_cofing_df WHERE logymd IS NOT NULL ) ) b ON a.item_id = b.item_id WHERE b.is_personalization_item = 1 AND b.item_type = 9 ) a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${network_group} AND ${pay_grade} AND ${register_dur} AND ${item_quality} AND ${item_id} AND grouping_name = '(all)' GROUP BY logymd, item_id ) SELECT logymd, a.item_id, item_name, a.send_gift_user_cnt, send_gift_cnt, gift_hot_val FROM t_item a INNER JOIN t_filter_item b ON a.item_id = b.item_id
```