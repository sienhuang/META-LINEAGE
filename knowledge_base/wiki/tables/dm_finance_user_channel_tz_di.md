# mt_dm.dm_finance_user_channel_tz_di  ()

> 

- 物理表: `mt_dm.dm_finance_user_channel_tz_di` · 引擎: doris/sr · 分层: dm · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `country` | derived | COALESCE(t2.first_mt_country, 'unknown') AS country |
| `date_range` | direct | t1.logymd AS date_range |
| `first_recall_pay_channel` | direct | t1.first_recall_pay_channel |
| `first_recall_pay_channel_config` | direct | t1.first_recall_pay_channel_config |
| `last_pay_channel_yd` | direct | t1.last_pay_channel_yd |
| `last_pay_channel_yd_config` | direct | t1.last_pay_channel_yd_config |
| `logymd` | direct | t1.logymd |
| `pay_channel` | direct | t1.pay_channel |
| `pay_channel_config` | direct | t1.pay_channel_config |
| `pay_user_type` | direct | t1.pay_user_type |
| `roleid` | direct | t1.roleid |

## 包含的底层指标
- 直接列: [[coda]], [[edge_value]], [[gp]], [[ios]], [[last_pay_channel_yd_config]], [[mp]], [[node_lelvel]], [[other]], [[pay_user_cnt]], [[pay_user_type]], [[ratio]], [[repurchase_rate]], [[source_node]], [[sum_pay_user_cnt]], [[target_node]], [[unipin]], [[unknown]], [[web_pag]]  (直接取列)

## 血缘
- 上游源表: mt_dim.dim_basic_role_zone_df
- 由 ETL 构建(task): 100041387
- 被这些指标使用: [[coda]], [[coda_extra]], [[coda渠道复购用户数]], [[coda渠道复购用户数_extra]], [[gp]], [[gp_extra]], [[gp渠道复购用户数]], [[gp渠道复购用户数_extra]], [[ios]], [[ios_extra]], [[ios渠道复购用户数]], [[ios渠道复购用户数_extra]], [[level]], [[line_复购率]], [[mobapay]], [[mobapay_extra]], [[mobapay渠道复购用户数]], [[mobapay渠道复购用户数_extra]], [[ratio]], [[source]], [[target]], [[unipin]], [[unipin_extra]], [[unipin渠道复购用户数]], [[unipin渠道复购用户数_extra]], [[value]], [[web_pag]], [[web_pag_extra]], [[web_pag渠道复购用户数]], [[web_pag渠道复购用户数_extra]] …(共 42)

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT logymd, pay_user_type, SUM(1) / count(DISTINCT logymd) AS pay_user_cnt, sum(sum(1)) over(PARTITION by logymd) as sum_pay_user_cnt FROM mt_dm.dm_finance_user_channel_tz_di a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${timezone_type} AND ${region} AND ${country} AND ${pay_user_type} AND ${pay_channel_config} GROUP BY logymd, pay_user_type
```