# gp_extra  `gp_extra`

**业务口径**: 统计周期内下单用户上一单的下单渠道

## 怎么算
**公式**: `sum(if(last_pay_channel_yd_config = 'gp', pay_user_cnt, null)) / if(max(sum_pay_user_cnt) > 0, max(sum_pay_user_cnt), 1)`

依赖的底层指标:
- [[gp]] (?) — `⚠️待D层` [待补] · 取数 `gp`
- [[last_pay_channel_yd_config]] (?) — `t1.last_pay_channel_yd_config` [已确认] · 取数 `last_pay_channel_yd_config`
- [[pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_user_cnt`
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`

## 数据来源
- 宽表: [[dm_finance_user_channel_tz_di]]
- dataset: ['300330']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **gp** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:gp`(D 层未自动解析,待补)
- **last_pay_channel_yd_config** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_user_channel_tz_di.last_pay_channel_yd_config`):
    - d0 `mt_dm.dm_finance_user_channel_tz_di.last_pay_channel_yd_config` ⇐ `cte:job.100041387_0:user_type_and_to_go.last_pay_channel_yd_config` [direct] `t1.last_pay_channel_yd_config`
    - d1 `cte:job.100041387_0:user_type_and_to_go.last_pay_channel_yd_config` ⇐ `subquery:job.100041387_0:t1.last_pay_channel_yd_config` [direct] `t1.last_pay_channel_yd_config`
    - d2 `subquery:job.100041387_0:t1.last_pay_channel_yd_config` ⇐ `subquery:job.100041387_0:t1_branch_1.last_pay_channel_yd_config` [derived] `UNION_BRANCH_COLUMN[7]`
    - d2 `subquery:job.100041387_0:t1.last_pay_channel_yd_config` ⇐ `subquery:job.100041387_0:t1_branch_2.last_pay_channel_yd_config` [derived] `UNION_BRANCH_COLUMN[7]`
    - d3 `subquery:job.100041387_0:t1_branch_1.last_pay_channel_yd_config` ⇐ `cte:job.100041387_0:user_type.last_pay_channel_config` [direct] `last_pay_channel_config AS last_pay_channel_yd_config`
    - d3 `subquery:job.100041387_0:t1_branch_2.last_pay_channel_yd_config` ⇐ `mt_dm.dm_finance_user_channel_tz_di.last_pay_channel_yd_config` [direct] `last_pay_channel_yd_config`
    - d4 `cte:job.100041387_0:user_type.last_pay_channel_config` ⇐ `cte:job.100041387_0:last_pay_channel.last_pay_channel_config` [direct] `t1.last_pay_channel_config`
    - d4 `mt_dm.dm_finance_user_channel_tz_di.last_pay_channel_yd_config` ⇐ `cte:job.100041387_0:user_type_and_to_go.last_pay_channel_yd_config` [direct] `t1.last_pay_channel_yd_config`
    - d5 `cte:job.100041387_0:last_pay_channel.last_pay_channel_config` ⇐ `subquery:job.100041387_0:lt.pay_channel_config` [derived] `COALESCE(lt.pay_channel_config, 'unknown') AS last_pay_channel_config`
    - d5 `cte:job.100041387_0:user_type_and_to_go.last_pay_channel_yd_config` ⇐ `subquery:job.100041387_0:t1.last_pay_channel_yd_config` [direct] `t1.last_pay_channel_yd_config`
    - d6 `subquery:job.100041387_0:lt.pay_channel_config` ⇐ `subquery:job.100041387_0:subquery_5.pay_channel` [derived] `CASE WHEN pay_channel = 'mobapay' THEN 'mp' WHEN pay_channel = 'web_coda' THEN '`
    - d6 `subquery:job.100041387_0:t1.last_pay_channel_yd_config` ⇐ `subquery:job.100041387_0:t1_branch_1.last_pay_channel_yd_config` [derived] `UNION_BRANCH_COLUMN[7]`
    - d6 `subquery:job.100041387_0:t1.last_pay_channel_yd_config` ⇐ `subquery:job.100041387_0:t1_branch_2.last_pay_channel_yd_config` [derived] `UNION_BRANCH_COLUMN[7]`
    - d7 `subquery:job.100041387_0:t1_branch_1.last_pay_channel_yd_config` ⇐ `cte:job.100041387_0:user_type.last_pay_channel_config` [direct] `last_pay_channel_config AS last_pay_channel_yd_config`
    - d7 `subquery:job.100041387_0:t1_branch_2.last_pay_channel_yd_config` ⇐ `mt_dm.dm_finance_user_channel_tz_di.last_pay_channel_yd_config` [direct] `last_pay_channel_yd_config`
    - d8 `cte:job.100041387_0:user_type.last_pay_channel_config` ⇐ `cte:job.100041387_0:last_pay_channel.last_pay_channel_config` [direct] `t1.last_pay_channel_config`
    - d8 `mt_dm.dm_finance_user_channel_tz_di.last_pay_channel_yd_config` ⇐ `cte:job.100041387_0:user_type_and_to_go.last_pay_channel_yd_config` [direct] `t1.last_pay_channel_yd_config`
- **pay_user_cnt** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:pay_user_cnt`(D 层未自动解析,待补)
- **sum_pay_user_cnt** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:sum_pay_user_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾