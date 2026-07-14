# test.dim_gamebi_special_config  ()

> 

- 物理表: `test.dim_gamebi_special_config` · 引擎: doris/sr · 分层: dim · 粒度: — · 类型: wide_table

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: —

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select concat("[", config_id, ",'total'] as pay_channel,[", pay_channel_amt, ",pay_amt] as pay_channel_amt,[", pay_channel_cnt, ",pay_cnt] as pay_channel_cnt") from( select group_concat(concat("'", config_id), "'") as config_id, group_concat(concat("pay_channel_amt[" , config_id, "]")) as pay_channel_amt, group_concat(concat("pay_channel_cnt[" , config_id, "]")) as pay_channel_cnt from test.dim_gamebi_special_config where config_type = 'pay_channel') tempView
```