# mt_ads.ads_decismart_actual_di  ()

> 

- 物理表: `mt_ads.ads_decismart_actual_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `actual_dau` | derived | ROUND(dau, 0) AS actual_dau /* 月日均 DAU */ |
| `actual_pay_amt_usd` | derived | ROUND(pay_amt, 2) AS actual_pay_amt_usd /* 月累计收入（美元） */ |
| `appname` | direct | appname |

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100055140
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
WITH actual AS ( SELECT logymd, actual_dau, actual_pay_amt_usd, appname, last_update_date, granularity_type, date_type FROM ( SELECT date_range AS logymd, actual_dau, actual_pay_amt_usd, appname, last_update_date, granularity_type, date_type FROM mt_ads.ads_decismart_actual_di ) t WHERE ${appname} AND ${logymd} AND ${granularity_type} AND ${date_type} ), target AS ( SELECT logymd, appname, metric_type, target_level, target_value FROM ( SELECT date_range AS logymd, appname, metric_type, target_level, target_value FROM mt_dim.dim_decismart_target_config WHERE ${appname} AND logymd IN ( SELECT MAX(logymd) FROM mt_dim.dim_decismart_target_config ) ) t WHERE ${appname} AND ${logymd} AND ${metric_type} AND ${target_level} ), join_t AS ( SELECT COALESCE(target.appname, actual.appname) AS appname, COALESCE(target.logymd, actual.logymd) AS logymd, last_update_date, target_value, actual_dau, actual_pay_amt_usd FROM target FULL JOIN actual ON target.appname = actual.appname AND target.logymd = actual.logymd ) SELECT logymd, MAX(last_update_date) AS last_update_date, SUM(target_value) AS target_value, SUM(actual_dau) AS actual_dau, SUM(actual_pay_amt_usd) AS actual_pay_amt_usd FROM join_t GROUP BY logymd
```