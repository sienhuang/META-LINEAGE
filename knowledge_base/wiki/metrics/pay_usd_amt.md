# pay_usd_amt  `pay_usd_amt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `pay_usd_amt/100`

依赖的底层指标:
- [[pay_usd_amt]] (?) — `pay_usd_amt` [已确认] · 取数 `pay_usd_amt`

## 数据来源
- 宽表: [[dm_finance_role_zone_tz_di]]
- dataset: ['300317']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
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