# mt_dm.dm_finance_role_zone_tz_di  ()

> 

- 物理表: `mt_dm.dm_finance_role_zone_tz_di` · 引擎: doris/sr · 分层: dm · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `actual_amt` | direct | actual_amt |
| `actual_usd_amt` | direct | actual_usd_amt |
| `bill_country` | direct | bill_country |
| `currency` | direct | t_charge.currency |
| `date_range` | direct | log_week AS date_range |
| `date_range_end` | direct | week_end_date AS date_range_end |
| `date_range_start` | direct | week_start_date AS date_range_start |
| `first_mt_country` | derived | COALESCE(t_basic.first_mt_country, 'unknown') AS first_mt_country |
| `logymd` | direct | week_end_date AS logymd |
| `pay_amt` | direct | pay_amt |
| `pay_channel` | direct | pay_channel |
| `pay_channel_type` | direct | pay_channel_type |
| `pay_type` | direct | pay_type |
| `pay_usd_amt` | direct | pay_usd_amt |
| `product_id` | direct | product_id |
| `product_money` | direct | product_money |
| `roleid` | direct | t_charge.roleid |
| `sub_pay_channel` | direct | sub_pay_channel |
| `sub_pay_channel_source` | direct | sub_pay_channel_source |
| `zone_type` | derived | CASE WHEN zoneid < 57000 THEN 0 ELSE 1 END AS zone_type |
| `zoneid` | direct | t_charge.zoneid |

## 包含的底层指标
- 直接列: [[active_cnt]], [[actual_usd_amt]], [[inside_actual_usd_amt]], [[inside_product_money]], [[logymd]], [[mp_product_money]], [[pay_amt]], [[pay_cnt]], [[pay_usd_amt]], [[point_active_cnt]], [[point_pay_amt]], [[point_register_cnt]], [[product_money]], [[register_cnt]], [[register_cnt_7d]], [[register_cnt_yd]], [[register_reten2]], [[register_reten7]], [[roleid]], [[third_product_money]], [[thrid_actual_usd_amt]], [[thrid_product_money]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100041174, 100041175, 100041176, 100041367, 100041902, 100042046
- 被这些指标使用: [[actual_rate]], [[bar_value]], [[exchange_rate]], [[inside_actual_rate]], [[inside_product_money]], [[inside_product_money_rate]], [[num]], [[num_7]], [[pay_amt]], [[pay_cnt]], [[pay_cnt_ratio]], [[pay_usd_amt]], [[product_money]], [[product_money_ratio]], [[sub_pay_subchannel_product_money_rate]], [[thrid_actual_rate]], [[thrid_product_money]], [[thrid_product_money_rate]], [[value]], [[value_7]], [[value_extra]], [[下单用户数]], [[实收率]], [[流水金额]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, sum(product_money) as product_money, sum(actual_usd_amt) as actual_usd_amt, sum(if(pay_channel_type = 1, product_money, null)) as third_product_money, sum(if(pay_channel = 'mobapay', product_money, null)) as mp_product_money from mt_dm.dm_finance_role_zone_tz_di a left outer join( select region, country_type , definition_type , country_code from mt_dim.dim_country where ${definition_type}) b on a.country = b.country_code where ${logymd} and zone_type = 0 and ${appname} and ${granularity_type} and ${date_type} and ${timezone_type} and ${country} and ${region} and ${bill_country} and ${sub_pay_channel} and ${pay_type} group by date_range
```