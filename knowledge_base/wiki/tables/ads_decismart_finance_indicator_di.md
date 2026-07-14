# mt_ads.ads_decismart_finance_indicator_di  ()

> 

- 物理表: `mt_ads.ads_decismart_finance_indicator_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `appname` | direct | appname |
| `country` | direct | ip_country AS country |
| `indicator_array` | derived | CAST(SPLIT(CONCAT_WS(',', COALESCE(visit_cnt, 0), COALESCE(goods_click_cnt, 0), COALESCE(channel_click_cnt, 0), COALESCE |

## 包含的底层指标
- 直接列: [[a1]], [[a2]], [[a3]], [[a4]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100041723
- 被这些指标使用: [[conver_rate1]], [[conver_rate2]], [[conver_rate3]], [[支付确认]], [[点击商品]], [[点击渠道]], [[访问次数]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT SUM(CAST(indicator_array[1] AS BIGINT)) AS a1, /**访问次数**/ SUM(CAST(indicator_array[2] AS BIGINT)) AS a2, /**点击商品次数**/ SUM(CAST(indicator_array[3] AS BIGINT)) AS a3, /**点击渠道次数**/ SUM(CAST(indicator_array[4] AS BIGINT)) AS a4 /**支付确认次数**/ FROM mt_ads.ads_decismart_finance_indicator_di a LEFT OUTER JOIN( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type}) b ON a.country = b.country_code WHERE ${logymd} and ${appname} and ${granularity_type} and ${date_type} and event = 'mp_ctr' and ${country} and ${region}
```