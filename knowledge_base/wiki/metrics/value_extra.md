# value_extra  `value_extra`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(product_money) / SUM(sum(product_money)) OVER (partition by logymd)`

依赖的底层指标:
- [[logymd]] (?) — `week_end_date AS logymd` [已确认] · 取数 `logymd`
- [[product_money]] (?) — `product_money` [已确认] · 取数 `product_money`
- [[roleid]] (?) — `t_charge.roleid` [已确认] · 取数 `roleid`

## 数据来源
- 宽表: [[dm_finance_role_zone_tz_di]]
- dataset: ['300314']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **logymd** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.logymd`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.logymd` ⇐ `cte:job.100041175_1:t_charge.week_end_date` [direct] `week_end_date AS logymd`
- **product_money** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.product_money`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041175_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041367_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041902_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041174_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041176_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100042046_1:t_charge.product_money` [direct] `product_money`
    - d1 `cte:job.100041175_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041367_1:t_charge.product_money` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041902_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041174_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041176_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100042046_1:t_charge.product_money` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041772_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041891_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100042035_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100042024_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041772_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041891_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041772_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041891_0:t2.product_money` [direct] `product_money`
- **roleid** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.roleid`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041175_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041367_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041902_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041174_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041176_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100042046_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d1 `cte:job.100041175_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041367_1:t_charge.roleid` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041902_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041174_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041176_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100042046_1:t_charge.roleid` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041772_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041891_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100042035_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100042024_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041772_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041891_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041772_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041891_0:t2.roleid` [direct] `roleid`

## 元信息
- 分类: money · tier: 长尾