# test.ads_decismart_pay_cube_di  ()

> 

- 物理表: `test.ads_decismart_pay_cube_di` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 包含的底层指标
- 直接列: [[pay_amt]], [[pay_cnt]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): —
- 被这些指标使用: [[充值玩家数]], [[收入金额]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
select date_range as logymd, sum(pay_amt) as pay_amt, sum(pay_cnt) as pay_cnt from test.ads_decismart_pay_cube_di where ${logymd} and ${appname} and ${granularity_type} and ${date_type} and ${amt_type} and ${definition_type} and ${grouping_name} and ${country} and ${region} and ${network_group} and ${pay_grade} and ${register_dur} group by date_range
```