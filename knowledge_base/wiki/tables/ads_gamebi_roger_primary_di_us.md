# mt_ads.ads_gamebi_roger_primary_di_us  ()

> 

- 物理表: `mt_ads.ads_gamebi_roger_primary_di_us` · 引擎: doris/sr · 分层: ads · 粒度: — · 类型: wide_table

## 字段(含直接生成表达式)
| 字段 | 生成方式 | 直接表达式 |
|---|---|---|
| `active_cnt` | derived | UNION_BRANCH_COLUMN[7] |
| `active_cnt_30days` | derived | UNION_BRANCH_COLUMN[8] |
| `active_cnt_30ds` | derived | UNION_BRANCH_COLUMN[29] |
| `active_cnt_7ds` | derived | UNION_BRANCH_COLUMN[27] |
| `active_cnt_90days` | derived | UNION_BRANCH_COLUMN[41] |
| `active_cnt_period` | derived | UNION_BRANCH_COLUMN[21] |
| `active_label` | derived | UNION_BRANCH_COLUMN[36] |
| `active_pay_30d_cnt` | derived | UNION_BRANCH_COLUMN[11] |
| `active_register_30d_cnt` | derived | UNION_BRANCH_COLUMN[13] |
| `active_register_pay_30d_cnt` | derived | UNION_BRANCH_COLUMN[12] |
| `actual_pay_amt` | derived | UNION_BRANCH_COLUMN[40] |
| `appname` | derived | UNION_BRANCH_COLUMN[45] |
| `arcade_label` | derived | UNION_BRANCH_COLUMN[35] |
| `channel` | derived | UNION_BRANCH_COLUMN[32] |
| `country` | derived | UNION_BRANCH_COLUMN[2] |
| `date_range` | derived | UNION_BRANCH_COLUMN[1] |
| `date_type` | derived | UNION_BRANCH_COLUMN[47] |
| `granularity_type` | derived | UNION_BRANCH_COLUMN[46] |
| `install_label` | derived | UNION_BRANCH_COLUMN[34] |
| `logymd` | derived | UNION_BRANCH_COLUMN[44] |
| `lose_cnt_30ds` | derived | UNION_BRANCH_COLUMN[28] |
| `lose_cnt_7ds` | derived | UNION_BRANCH_COLUMN[26] |
| `network` | derived | UNION_BRANCH_COLUMN[4] |
| `network_group` | derived | UNION_BRANCH_COLUMN[30] |
| `new_active_cnt` | derived | UNION_BRANCH_COLUMN[24] |
| `new_type` | derived | UNION_BRANCH_COLUMN[33] |
| `nologin_cnt_14days` | derived | UNION_BRANCH_COLUMN[38] |
| `nologin_cnt_30days` | derived | UNION_BRANCH_COLUMN[15] |
| `old_reten_cnt` | derived | UNION_BRANCH_COLUMN[20] |
| `online_dur` | derived | UNION_BRANCH_COLUMN[23] |
| `os` | derived | UNION_BRANCH_COLUMN[3] |
| `pay_amt` | derived | UNION_BRANCH_COLUMN[10] |
| `pay_amt_exrate` | derived | UNION_BRANCH_COLUMN[18] |
| `pay_cnt` | derived | UNION_BRANCH_COLUMN[9] |
| `pay_cnt_period` | derived | UNION_BRANCH_COLUMN[22] |
| `pure_register_cnt` | derived | UNION_BRANCH_COLUMN[6] |
| `pure_reten_cnt` | derived | UNION_BRANCH_COLUMN[19] |
| `recurring_14days_reten_cnt` | derived | UNION_BRANCH_COLUMN[39] |
| `recurring_cnt_14days` | derived | UNION_BRANCH_COLUMN[37] |
| `recurring_cnt_30days` | derived | UNION_BRANCH_COLUMN[14] |
| `recurring_reten_cnt` | derived | UNION_BRANCH_COLUMN[17] |
| `register_cnt` | derived | UNION_BRANCH_COLUMN[5] |
| `register_cnt_total` | derived | UNION_BRANCH_COLUMN[25] |
| `register_reten_cnt` | derived | UNION_BRANCH_COLUMN[16] |
| `user_type` | derived | UNION_BRANCH_COLUMN[31] |
| `vaild_user_cnt` | derived | UNION_BRANCH_COLUMN[42] |
| `vaild_user_online_dur` | derived | UNION_BRANCH_COLUMN[43] |

## 包含的底层指标
- 直接列: [[active_cnt]], [[pay_amt]], [[register_cnt]], [[register_reten_cnt_2]], [[register_reten_cnt_2_total]], [[register_reten_cnt_3]], [[register_reten_cnt_3_total]], [[register_reten_cnt_7]], [[register_reten_cnt_7_total]]  (直接取列)

## 血缘
- 上游源表: —
- 由 ETL 构建(task): 100048520
- 被这些指标使用: [[register_reten_cnt_2_total]], [[register_reten_cnt_3_total]], [[register_reten_cnt_7_total]], [[value]], [[value_3]], [[value_7]], [[日均DAU]], [[日均收入金额]], [[日均新增玩家数]], [[渠道]]

## 被 dataset 取数的 SQL(C 层复用口径)
```sql
SELECT date_range AS logymd, SUM(register_cnt) AS register_cnt, SUM(active_cnt) AS active_cnt, SUM(pay_amt) AS pay_amt, SUM(recurring_cnt_30days) AS recurring_cnt_30days, SUM(pay_cnt) AS pay_cnt, SUM(online_dur) AS online_dur, SUM(register_cnt_total) AS register_cnt_total FROM mt_ads.ads_gamebi_roger_primary_di_us a LEFT OUTER JOIN ( SELECT region, country_type, definition_type, country_code FROM mt_dim.dim_country WHERE ${definition_type} ) b ON a.country = b.country_code WHERE ${logymd} AND ${appname} AND ${granularity_type} AND ${date_type} AND ${country} AND ${region} AND ${network_group} AND ${new_type} AND ${install_label} AND ${os} AND ${channel} AND ${sub_channel} GROUP BY date_range
```