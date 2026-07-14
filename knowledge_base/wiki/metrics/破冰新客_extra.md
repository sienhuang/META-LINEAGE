# 破冰新客_extra  `破冰新客_extra`

**业务口径**: 统计周期内下单用户数，按照用户类型分组

## 怎么算
**公式**: `sum(if(pay_user_type = 0, pay_user_cnt, null)) / if(max(sum_pay_user_cnt) = 0, 1, max(sum_pay_user_cnt))`

依赖的底层指标:
- [[pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_user_cnt`
- [[pay_user_type]] (?) — `t1.pay_user_type` [已确认] · 取数 `pay_user_type`
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`

## 数据来源
- 宽表: [[dm_finance_user_channel_tz_di]]
- dataset: ['300328']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **pay_user_cnt** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:pay_user_cnt`(D 层未自动解析,待补)
- **pay_user_type** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_user_channel_tz_di.pay_user_type`):
    - d0 `mt_dm.dm_finance_user_channel_tz_di.pay_user_type` ⇐ `cte:job.100041387_0:user_type_and_to_go.pay_user_type` [direct] `t1.pay_user_type`
    - d1 `cte:job.100041387_0:user_type_and_to_go.pay_user_type` ⇐ `subquery:job.100041387_0:t1.pay_user_type` [direct] `t1.pay_user_type`
    - d2 `subquery:job.100041387_0:t1.pay_user_type` ⇐ `subquery:job.100041387_0:t1_branch_1.pay_user_type` [derived] `UNION_BRANCH_COLUMN[5]`
    - d2 `subquery:job.100041387_0:t1.pay_user_type` ⇐ `subquery:job.100041387_0:t1_branch_2.pay_user_type` [derived] `UNION_BRANCH_COLUMN[5]`
    - d3 `subquery:job.100041387_0:t1_branch_1.pay_user_type` ⇐ `cte:job.100041387_0:user_type.user_type` [direct] `user_type AS pay_user_type`
    - d3 `subquery:job.100041387_0:t1_branch_2.pay_user_type` ⇐ `mt_dm.dm_finance_user_channel_tz_di.pay_user_type` [direct] `pay_user_type`
    - d4 `cte:job.100041387_0:user_type.user_type` ⇐ `cte:job.100041387_0:user_first_date.his_first_pay_date` [derived] `CASE WHEN t2.his_first_pay_date = t1.logymd THEN 0 WHEN t3.his_first_pay_date = `
    - d4 `cte:job.100041387_0:user_type.user_type` ⇐ `cte:job.100041387_0:last_pay_channel.logymd` [derived] `CASE WHEN t2.his_first_pay_date = t1.logymd THEN 0 WHEN t3.his_first_pay_date = `
    - d4 `cte:job.100041387_0:user_type.user_type` ⇐ `cte:job.100041387_0:pay_channel_user_first_date.his_first_pay_date` [derived] `CASE WHEN t2.his_first_pay_date = t1.logymd THEN 0 WHEN t3.his_first_pay_date = `
    - d4 `mt_dm.dm_finance_user_channel_tz_di.pay_user_type` ⇐ `cte:job.100041387_0:user_type_and_to_go.pay_user_type` [direct] `t1.pay_user_type`
    - d5 `cte:job.100041387_0:user_first_date.his_first_pay_date` ⇐ `mt_dwm.dwm_charge_role_zone_df.his_first_pay_time` [aggregated] `MIN(SUBSTRING(his_first_pay_time, 1, 10)) AS his_first_pay_date`
    - d5 `cte:job.100041387_0:last_pay_channel.logymd` ⇐ `subquery:job.100041387_0:pay.logymd` [direct] `pay.logymd`
    - d5 `cte:job.100041387_0:pay_channel_user_first_date.his_first_pay_date` ⇐ `mt_dwm.dwm_charge_role_zone_df.his_first_pay_time` [aggregated] `MIN(SUBSTRING(his_first_pay_time, 1, 10)) AS his_first_pay_date`
    - d5 `cte:job.100041387_0:user_type_and_to_go.pay_user_type` ⇐ `subquery:job.100041387_0:t1.pay_user_type` [direct] `t1.pay_user_type`
    - d6 `subquery:job.100041387_0:pay.logymd` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.logymd` [direct] `logymd`
    - d6 `subquery:job.100041387_0:t1.pay_user_type` ⇐ `subquery:job.100041387_0:t1_branch_1.pay_user_type` [derived] `UNION_BRANCH_COLUMN[5]`
    - d6 `subquery:job.100041387_0:t1.pay_user_type` ⇐ `subquery:job.100041387_0:t1_branch_2.pay_user_type` [derived] `UNION_BRANCH_COLUMN[5]`
    - d7 `subquery:job.100041387_0:t1_branch_1.pay_user_type` ⇐ `cte:job.100041387_0:user_type.user_type` [direct] `user_type AS pay_user_type`
    - d7 `subquery:job.100041387_0:t1_branch_2.pay_user_type` ⇐ `mt_dm.dm_finance_user_channel_tz_di.pay_user_type` [direct] `pay_user_type`
    - d8 `cte:job.100041387_0:user_type.user_type` ⇐ `cte:job.100041387_0:user_first_date.his_first_pay_date` [derived] `CASE WHEN t2.his_first_pay_date = t1.logymd THEN 0 WHEN t3.his_first_pay_date = `
- **sum_pay_user_cnt** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:sum_pay_user_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾