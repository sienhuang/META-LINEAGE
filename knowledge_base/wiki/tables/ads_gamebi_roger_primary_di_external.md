# mt_ads.ads_gamebi_roger_primary_di_external  ()

> 

- 物理表: `mt_ads.ads_gamebi_roger_primary_di_external` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `channel` | derived | COALESCE(t3.channel, 'unknown') AS channel |
| `country` | derived | COALESCE(t3.country, 'unknown') AS country |
| `date_range` | direct | t3.logymd AS date_range |
| `logymd` | direct | t3.logymd AS logymd |
| `pay_cnt` | derived | COALESCE(t3.pay_cnt, 0) AS pay_cnt |
| `pay_reten_cnt_2d` | direct | t3.pay_reten_cnt_2d AS pay_reten_cnt_2d |
| `pay_reten_cnt_7d` | direct | t3.pay_reten_cnt_7d AS pay_reten_cnt_7d |

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100052129, 100052894
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT date_range AS date_range ${pushdown_dims}, SUM(pay_cnt) AS pay_cnt, SUM(IF(pay_reten_cnt_2d IS NULL, 0, pay_cnt)) as pay_cnt_2d, SUM(IF(pay_reten_cnt_7d IS NULL, 0, pay_cnt)) as pay_cnt_7d, SUM(pay_reten_cnt_2d) AS pay_reten_cnt_2d, SUM(pay_reten_cnt_7d) AS pay_reten_cnt_7d FROM mt_ads.ads_gamebi_roger_primary_di_external a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${network_group} AND ${new_type} AND ${install_label} AND ${os} AND ${channel} AND user_type = 2 GROUP BY date_range ${pushdown_dims}
```