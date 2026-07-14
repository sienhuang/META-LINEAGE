# compet_act_cnt  `compet_act_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `compet_act_cnt`

依赖的底层指标:
- [[compet_act_cnt]] (?) — `COALESCE(tb1.compet_act_cnt, 0) AS compet_act_cnt` [已确认] · 取数 `compet_act_cnt`

## 数据来源
- 宽表: [[ads_gamebi_competitor_account_mi]]
- dataset: ['300069']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **compet_act_cnt** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 跨任务血缘链(`mt_ads.ads_gamebi_competitor_account_di.compet_act_cnt`):
    - d0 `mt_ads.ads_gamebi_competitor_account_di.compet_act_cnt` ⇐ `subquery:job.100024326_1:tb1.compet_act_cnt` [derived] `COALESCE(tb1.compet_act_cnt, 0) AS compet_act_cnt`
    - d1 `subquery:job.100024326_1:tb1.compet_act_cnt` ⇐ `subquery:job.100024326_1:tb1_branch_1.compet_act_cnt` [derived] `UNION_BRANCH_COLUMN[9]`
    - d1 `subquery:job.100024326_1:tb1.compet_act_cnt` ⇐ `subquery:job.100024326_1:tb1_branch_2.compet_act_cnt` [derived] `UNION_BRANCH_COLUMN[9]`
    - d2 `subquery:job.100024326_1:tb1_branch_1.compet_act_cnt` ⇐ `cte:job.100024326_1:ads_compete.accountid` [aggregated] `COUNT(DISTINCT accountid) AS compet_act_cnt`
    - d2 `subquery:job.100024326_1:tb1_branch_2.compet_act_cnt` ⇐ `cte:job.100024326_1:active_new_battle.accountid` [aggregated] `COUNT(DISTINCT accountid) AS compet_act_cnt`
    - d3 `cte:job.100024326_1:ads_compete.accountid` ⇐ `cte:job.100024326_1:competitor_account_di.accountid` [direct] `cpt.accountid /* 关联不上为null */`
    - d3 `cte:job.100024326_1:active_new_battle.accountid` ⇐ `subquery:job.100024326_1:t1.roleid` [direct] `t1.roleid AS accountid`
    - d4 `cte:job.100024326_1:competitor_account_di.accountid` ⇐ `mt_dwd.dwd_competitor_account_di.accountid` [direct] `accountid`
    - d4 `subquery:job.100024326_1:t1.roleid` ⇐ `subquery:job.100024326_1:t1_branch_1.roleid` [derived] `UNION_BRANCH_COLUMN[2]`
    - d4 `subquery:job.100024326_1:t1.roleid` ⇐ `subquery:job.100024326_1:t1_branch_2.roleid` [derived] `UNION_BRANCH_COLUMN[2]`
    - d4 `subquery:job.100024326_1:t1.roleid` ⇐ `subquery:job.100024326_1:t1_branch_3.roleid` [derived] `UNION_BRANCH_COLUMN[2]`
    - d5 `mt_dwd.dwd_competitor_account_di.accountid` ⇐ `cte:job.100002889_0:app_all_config.accountid` [direct] `accountid`
    - d5 `subquery:job.100024326_1:t1_branch_1.roleid` ⇐ `cte:job.100024326_1:active_di.roleid` [direct] `roleid`
    - d5 `subquery:job.100024326_1:t1_branch_2.roleid` ⇐ `cte:job.100024326_1:dim_basic.roleid` [direct] `roleid`
    - d5 `subquery:job.100024326_1:t1_branch_3.roleid` ⇐ `cte:job.100024326_1:recurring_di_role.roleid` [direct] `roleid`
    - d6 `cte:job.100002889_0:app_all_config.accountid` ⇐ `subquery:job.100002889_0:app_all_config_branch_1.accountid` [derived] `UNION_BRANCH_COLUMN[1]`
    - d6 `cte:job.100002889_0:app_all_config.accountid` ⇐ `subquery:job.100002889_0:app_all_config_branch_2.accountid` [derived] `UNION_BRANCH_COLUMN[1]`
    - d6 `cte:job.100024326_1:active_di.roleid` ⇐ `mt_dwm.dwm_active_role_zone_di.roleid` [direct] `roleid`
    - d6 `cte:job.100024326_1:dim_basic.roleid` ⇐ `mt_dim.dim_basic_role_zone_df.roleid` [direct] `roleid`
    - d6 `cte:job.100024326_1:recurring_di_role.roleid` ⇐ `mt_dim.dim_gamebi_active_pay_di.roleid` [direct] `roleid`

## 元信息
- 分类: other · tier: 长尾