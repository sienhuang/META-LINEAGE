# mlbb_value  `mlbb_value`

**业务口径**: (竞品重合玩家数)/(MLBB大盘玩家数) * 100%

## 怎么算
**公式**: `sum(mlbb_act_cnt)`

依赖的底层指标:
- [[mlbb_act_cnt]] (?) — `COALESCE(tb2.compet_act_cnt, 0) AS mlbb_act_cnt` [已确认] · 取数 `mlbb_act_cnt`
- [[mlbb_day_login_duration]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_day_login_duration`
- [[mlbb_reten_cnt_2days]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_reten_cnt_2days`
- [[mlbb_reten_cnt_7days]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_reten_cnt_7days`
- [[mlbb_reten_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_reten_cnt_30days`

## 数据来源
- 宽表: [[ads_gamebi_competitor_account_di]]
- dataset: ['300061']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **mlbb_act_cnt** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 跨任务血缘链(`mt_ads.ads_gamebi_competitor_account_di.mlbb_act_cnt`):
    - d0 `mt_ads.ads_gamebi_competitor_account_di.mlbb_act_cnt` ⇐ `subquery:job.100024326_1:tb2.compet_act_cnt` [derived] `COALESCE(tb2.compet_act_cnt, 0) AS mlbb_act_cnt`
    - d1 `subquery:job.100024326_1:tb2.compet_act_cnt` ⇐ `cte:job.100024326_1:active_new_battle.accountid` [aggregated] `COUNT(DISTINCT accountid) AS compet_act_cnt`
    - d2 `cte:job.100024326_1:active_new_battle.accountid` ⇐ `subquery:job.100024326_1:t1.roleid` [direct] `t1.roleid AS accountid`
    - d3 `subquery:job.100024326_1:t1.roleid` ⇐ `subquery:job.100024326_1:t1_branch_1.roleid` [derived] `UNION_BRANCH_COLUMN[2]`
    - d3 `subquery:job.100024326_1:t1.roleid` ⇐ `subquery:job.100024326_1:t1_branch_2.roleid` [derived] `UNION_BRANCH_COLUMN[2]`
    - d3 `subquery:job.100024326_1:t1.roleid` ⇐ `subquery:job.100024326_1:t1_branch_3.roleid` [derived] `UNION_BRANCH_COLUMN[2]`
    - d4 `subquery:job.100024326_1:t1_branch_1.roleid` ⇐ `cte:job.100024326_1:active_di.roleid` [direct] `roleid`
    - d4 `subquery:job.100024326_1:t1_branch_2.roleid` ⇐ `cte:job.100024326_1:dim_basic.roleid` [direct] `roleid`
    - d4 `subquery:job.100024326_1:t1_branch_3.roleid` ⇐ `cte:job.100024326_1:recurring_di_role.roleid` [direct] `roleid`
    - d5 `cte:job.100024326_1:active_di.roleid` ⇐ `mt_dwm.dwm_active_role_zone_di.roleid` [direct] `roleid`
    - d5 `cte:job.100024326_1:dim_basic.roleid` ⇐ `mt_dim.dim_basic_role_zone_df.roleid` [direct] `roleid`
    - d5 `cte:job.100024326_1:recurring_di_role.roleid` ⇐ `mt_dim.dim_gamebi_active_pay_di.roleid` [direct] `roleid`
    - d6 `mt_dwm.dwm_active_role_zone_di.roleid` ⇐ `cte:job.100000819_1:login_info.roleid` [direct] `login_info.roleid`
    - d6 `mt_dim.dim_basic_role_zone_df.roleid` ⇐ `subquery:job.100001206_3:a.roleid` [direct] `roleid`
    - d6 `mt_dim.dim_gamebi_active_pay_di.roleid` ⇐ `subquery:job.100008237_0:t.roleid` [direct] `roleid`
    - d6 `mt_dim.dim_gamebi_active_pay_di.roleid` ⇐ `subquery:job.100008287_0:t.roleid` [direct] `roleid`
    - d6 `mt_dim.dim_gamebi_active_pay_di.roleid` ⇐ `subquery:job.100027978_0:t.roleid` [direct] `roleid`
    - d7 `cte:job.100000819_1:login_info.roleid` ⇐ `subquery:job.100000819_1:c.roleid` [direct] `roleid`
    - d7 `subquery:job.100001206_3:a.roleid` ⇐ `subquery:job.100001206_3:createrole.roleid` [direct] `createrole.roleid`
    - d7 `subquery:job.100008237_0:t.roleid` ⇐ `cte:job.100008237_0:active_pay_role.roleid` [direct] `active_role.roleid AS roleid`
- **mlbb_day_login_duration** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:mlbb_day_login_duration`(D 层未自动解析,待补)
- **mlbb_reten_cnt_2days** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:mlbb_reten_cnt_2days`(D 层未自动解析,待补)
- **mlbb_reten_cnt_7days** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:mlbb_reten_cnt_7days`(D 层未自动解析,待补)
- **mlbb_reten_cnt_30days** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:mlbb_reten_cnt_30days`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾