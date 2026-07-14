# exchange_rate  `exchange_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pay_usd_amt)/SUM(cast(pay_amt as decimal(38,0)))`

依赖的底层指标:
- [[pay_amt]] (?) — `UNION_BRANCH_COLUMN[10]` [已确认] · 取数 `pay_amt`
- [[pay_usd_amt]] (?) — `pay_usd_amt` [已确认] · 取数 `pay_usd_amt`

## 数据来源
- 宽表: [[dm_finance_role_zone_tz_di]]
- dataset: ['300317']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **pay_amt** @ `mt_ads.ads_gamebi_roger_primary_di_us`
  - 跨任务血缘链(`mt_ads.ads_gamebi_roger_primary_di_us.pay_amt`):
    - d0 `mt_ads.ads_gamebi_roger_primary_di_us.pay_amt` ⇐ `subquery:job.100048520_0:final_insert_branch_1.pay_amt` [derived] `UNION_BRANCH_COLUMN[10]`
    - d0 `mt_ads.ads_gamebi_roger_primary_di_us.pay_amt` ⇐ `subquery:job.100048520_0:final_insert_branch_2.pay_amt` [derived] `UNION_BRANCH_COLUMN[10]`
    - d1 `subquery:job.100048520_0:final_insert_branch_1.pay_amt` ⇐ `mt_ads.ads_gamebi_roger_primary_di.pay_amt` [direct] `pay_amt /*	付费金额(美分) */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100020886_2:subquery_2.pay_amt` [direct] `pay_amt /*	付费金额(美分) */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100021029_2:subquery_8.pay_amt` [direct] `pay_amt /*	付费金额(美分) */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100033108_0:t1.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100037206_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100022588_2:b.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100025287_0:subquery_2.pay_amt` [direct] `pay_amt /*	付费金额(美分) */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100030100_0:subquery_7.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100031072_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100031311_1:t2.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100037162_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100039140_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100041395_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100041408_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100041407_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100041406_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100041409_1:a.pay_amt` [derived] `COALESCE(pay_amt, 0) AS pay_amt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.pay_amt` ⇐ `subquery:job.100052167_1:t3.pay_amt` [derived] `COALESCE(t3.pay_amt, 0) AS pay_amt`
- **pay_usd_amt** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt` ⇐ `cte:job.100041175_1:t_charge.pay_usd_amt` [direct] `pay_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt` ⇐ `cte:job.100041367_1:t_charge.pay_usd_amt` [direct] `pay_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt` ⇐ `cte:job.100041902_1:t_charge.pay_usd_amt` [direct] `pay_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt` ⇐ `cte:job.100041174_1:t_charge.pay_usd_amt` [direct] `pay_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt` ⇐ `cte:job.100041176_1:t_charge.pay_usd_amt` [direct] `pay_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.pay_usd_amt` ⇐ `cte:job.100042046_1:t_charge.pay_usd_amt` [direct] `pay_usd_amt`
    - d1 `cte:job.100041175_1:t_charge.pay_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` [aggregated] `SUM(pay_usd_amt) AS pay_usd_amt /* ISO年份-周数 */`
    - d1 `cte:job.100041367_1:t_charge.pay_usd_amt` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_usd_amt` [aggregated] `SUM(pay_usd_amt) AS pay_usd_amt`
    - d1 `cte:job.100041902_1:t_charge.pay_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` [aggregated] `SUM(pay_usd_amt) AS pay_usd_amt`
    - d1 `cte:job.100041174_1:t_charge.pay_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` [aggregated] `SUM(pay_usd_amt) AS pay_usd_amt`
    - d1 `cte:job.100041176_1:t_charge.pay_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` [aggregated] `SUM(pay_usd_amt) AS pay_usd_amt`
    - d1 `cte:job.100042046_1:t_charge.pay_usd_amt` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_usd_amt` [aggregated] `SUM(pay_usd_amt) AS pay_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100041772_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100041891_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100042035_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100042024_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100041772_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100041891_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100041772_0:t2.pay_usd_amt` [direct] `pay_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_usd_amt` ⇐ `subquery:job.100041891_0:t2.pay_usd_amt` [direct] `pay_usd_amt`

## 元信息
- 分类: money · tier: 长尾