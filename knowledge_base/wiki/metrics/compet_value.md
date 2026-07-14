# compet_value  `compet_value`

**业务口径**: (竞品重合玩家数)/(MLBB大盘玩家数) * 100%

## 怎么算
**公式**: `sum(compet_act_cnt)/sum(mlbb_act_cnt)`

依赖的底层指标:
- [[compet_act_cnt]] (?) — `COALESCE(tb1.compet_act_cnt, 0) AS compet_act_cnt` [已确认] · 取数 `compet_act_cnt`
- [[mlbb_act_cnt]] (?) — `COALESCE(tb2.compet_act_cnt, 0) AS mlbb_act_cnt` [已确认] · 取数 `mlbb_act_cnt`
- [[compet_day_login_duration]] (?) — `COALESCE(tb1.compet_day_login_duration, 0) AS compet_day_login_duration` [已确认] · 取数 `compet_day_login_duration`
- [[compet_reten_cnt_2days]] (?) — `⚠️待D层` [待补] · 取数 `compet_reten_cnt_2days`
- [[compet_reten_cnt_7days]] (?) — `⚠️待D层` [待补] · 取数 `compet_reten_cnt_7days`
- [[compet_reten_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `compet_reten_cnt_30days`

## 数据来源
- 宽表: [[ads_gamebi_competitor_account_di]]
- dataset: ['300061']  · 产品线 scope: ['mlbb']

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
- **compet_day_login_duration** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 跨任务血缘链(`mt_ads.ads_gamebi_competitor_account_di.compet_day_login_duration`):
    - d0 `mt_ads.ads_gamebi_competitor_account_di.compet_day_login_duration` ⇐ `subquery:job.100024326_1:tb1.compet_day_login_duration` [derived] `COALESCE(tb1.compet_day_login_duration, 0) AS compet_day_login_duration`
    - d1 `subquery:job.100024326_1:tb1.compet_day_login_duration` ⇐ `subquery:job.100024326_1:tb1_branch_1.compet_day_login_duration` [derived] `UNION_BRANCH_COLUMN[8]`
    - d1 `subquery:job.100024326_1:tb1.compet_day_login_duration` ⇐ `subquery:job.100024326_1:tb1_branch_2.compet_day_login_duration` [derived] `UNION_BRANCH_COLUMN[8]`
    - d2 `subquery:job.100024326_1:tb1_branch_1.compet_day_login_duration` ⇐ `cte:job.100024326_1:ads_compete.day_login_duration` [aggregated] `SUM(day_login_duration) AS compet_day_login_duration`
    - d2 `subquery:job.100024326_1:tb1_branch_2.compet_day_login_duration` ⇐ `cte:job.100024326_1:active_new_battle.day_login_duration` [aggregated] `SUM(day_login_duration) AS compet_day_login_duration`
    - d3 `cte:job.100024326_1:ads_compete.day_login_duration` ⇐ `subquery:job.100024326_1:con.day_login_duration` [derived] `IF(cpt.accountid IS NULL, 0, con.day_login_duration) AS day_login_duration`
    - d3 `cte:job.100024326_1:ads_compete.day_login_duration` ⇐ `cte:job.100024326_1:competitor_account_di.accountid` [derived] `IF(cpt.accountid IS NULL, 0, con.day_login_duration) AS day_login_duration`
    - d3 `cte:job.100024326_1:active_new_battle.day_login_duration` ⇐ `cte:job.100024326_1:active_di.day_login_duration` [direct] `t4.day_login_duration`
    - d4 `subquery:job.100024326_1:con.day_login_duration` ⇐ `cte:job.100024326_1:active_new_battle.day_login_duration` [direct] `a.day_login_duration`
    - d4 `cte:job.100024326_1:competitor_account_di.accountid` ⇐ `mt_dwd.dwd_competitor_account_di.accountid` [direct] `accountid`
    - d4 `cte:job.100024326_1:active_di.day_login_duration` ⇐ `mt_dwm.dwm_active_role_zone_di.day_login_duration` [aggregated] `MAX(day_login_duration) AS day_login_duration`
    - d5 `cte:job.100024326_1:active_new_battle.day_login_duration` ⇐ `cte:job.100024326_1:active_di.day_login_duration` [direct] `t4.day_login_duration`
    - d5 `mt_dwd.dwd_competitor_account_di.accountid` ⇐ `cte:job.100002889_0:app_all_config.accountid` [direct] `accountid`
    - d5 `mt_dwm.dwm_active_role_zone_di.day_login_duration` ⇐ `cte:job.100000819_1:logout_info.day_login_duration` [direct] `logout_info.day_login_duration`
    - d6 `cte:job.100024326_1:active_di.day_login_duration` ⇐ `mt_dwm.dwm_active_role_zone_di.day_login_duration` [aggregated] `MAX(day_login_duration) AS day_login_duration`
    - d6 `cte:job.100002889_0:app_all_config.accountid` ⇐ `subquery:job.100002889_0:app_all_config_branch_1.accountid` [derived] `UNION_BRANCH_COLUMN[1]`
    - d6 `cte:job.100002889_0:app_all_config.accountid` ⇐ `subquery:job.100002889_0:app_all_config_branch_2.accountid` [derived] `UNION_BRANCH_COLUMN[1]`
    - d6 `cte:job.100000819_1:logout_info.day_login_duration` ⇐ `subquery:job.100000819_1:t.online_time` [aggregated] `SUM(online_time) AS day_login_duration`
    - d7 `mt_dwm.dwm_active_role_zone_di.day_login_duration` ⇐ `cte:job.100000819_1:logout_info.day_login_duration` [direct] `logout_info.day_login_duration`
    - d7 `subquery:job.100002889_0:app_all_config_branch_1.accountid` ⇐ `cte:job.100002889_0:app_all_config1.accountid` [direct] `accountid`
- **compet_reten_cnt_2days** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:compet_reten_cnt_2days`(D 层未自动解析,待补)
- **compet_reten_cnt_7days** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:compet_reten_cnt_7days`(D 层未自动解析,待补)
- **compet_reten_cnt_30days** @ `mt_ads.ads_gamebi_competitor_account_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_competitor_account_di:compet_reten_cnt_30days`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾