# actual_rate  `actual_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(actual_usd_amt) / sum(product_money) * 100`

依赖的底层指标:
- [[actual_usd_amt]] (?) — `actual_usd_amt` [已确认] · 取数 `actual_usd_amt`
- [[product_money]] (?) — `product_money` [已确认] · 取数 `product_money`

## 数据来源
- 宽表: [[dm_finance_role_zone_tz_di]]
- dataset: ['300317', '300323']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **actual_usd_amt** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt` ⇐ `cte:job.100041175_1:t_charge.actual_usd_amt` [direct] `actual_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt` ⇐ `cte:job.100041367_1:t_charge.actual_usd_amt` [direct] `actual_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt` ⇐ `cte:job.100041902_1:t_charge.actual_usd_amt` [direct] `actual_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt` ⇐ `cte:job.100041174_1:t_charge.actual_usd_amt` [direct] `actual_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt` ⇐ `cte:job.100041176_1:t_charge.actual_usd_amt` [direct] `actual_usd_amt`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.actual_usd_amt` ⇐ `cte:job.100042046_1:t_charge.actual_usd_amt` [direct] `actual_usd_amt`
    - d1 `cte:job.100041175_1:t_charge.actual_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` [aggregated] `SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */`
    - d1 `cte:job.100041367_1:t_charge.actual_usd_amt` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_net_receipts_usd_amt` [aggregated] `SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */`
    - d1 `cte:job.100041902_1:t_charge.actual_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` [aggregated] `SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */`
    - d1 `cte:job.100041174_1:t_charge.actual_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` [aggregated] `SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */`
    - d1 `cte:job.100041176_1:t_charge.actual_usd_amt` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` [aggregated] `SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */`
    - d1 `cte:job.100042046_1:t_charge.actual_usd_amt` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_net_receipts_usd_amt` [aggregated] `SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100041772_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100041891_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100042035_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100042024_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100041772_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100041891_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100041772_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.pay_net_receipts_usd_amt` ⇐ `subquery:job.100041891_0:t2.pay_net_receipts_usd_amt` [direct] `pay_net_receipts_usd_amt`
  - 整条链路 SQL:

```sql
WITH
t_charge AS (
    SELECT
        SUM(pay_net_receipts_usd_amt) AS actual_usd_amt /* 美金实收 */,
        bill_country /* 账单国家 */,
        currency /* 币种 */,
        logymd,
        pay_channel_config AS pay_channel,
        pay_channel_type,
        pay_type,
        product_id,
        roleid,
        sub_pay_channel_config AS sub_pay_channel,
        sub_pay_channel_config_source AS sub_pay_channel_source,
        zoneid
    FROM mt_dwm.dwm_mcgg_charge_role_zone_tz_di AS dwm_mcgg_charge_role_zone_tz_di
    WHERE logymd = '2026-05-30' AND timezone_type = 1
    GROUP BY roleid, zoneid, pay_channel_config, sub_pay_channel_config, sub_pay_channel_config_source, pay_channel_type, pay_type, bill_country /* 账单国家 */, currency /* 币种 */, logymd, product_id
),
dm_finance_role_zone_tz_di AS (
    SELECT
        actual_usd_amt,
        bill_country,
        t_charge.currency,
        logymd AS date_range,
        logymd AS date_range_end,
        logymd AS date_range_start,
        pay_channel,
        pay_channel_type,
        pay_type,
        product_id,
        t_charge.roleid,
        sub_pay_channel,
        sub_pay_channel_source,
        t_charge.zoneid
    FROM t_charge
)
SELECT
    dm_finance_role_zone_tz_di.actual_usd_amt
FROM dm_finance_role_zone_tz_di;
```
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
  - 整条链路 SQL:

```sql
WITH
t_charge AS (
    SELECT
        bill_country /* 账单国家 */,
        currency /* 币种 */,
        logymd,
        pay_channel_config AS pay_channel,
        pay_channel_type,
        pay_type,
        product_id,
        SUM(product_money) AS product_money /* 定价流水 */,
        roleid,
        sub_pay_channel_config AS sub_pay_channel,
        sub_pay_channel_config_source AS sub_pay_channel_source,
        zoneid
    FROM mt_dwm.dwm_mcgg_charge_role_zone_tz_di AS dwm_mcgg_charge_role_zone_tz_di
    WHERE logymd = '2026-05-30' AND timezone_type = 1
    GROUP BY roleid, zoneid, pay_channel_config, sub_pay_channel_config, sub_pay_channel_config_source, pay_channel_type, pay_type, bill_country /* 账单国家 */, currency /* 币种 */, logymd, product_id
),
dm_finance_role_zone_tz_di AS (
    SELECT
        bill_country,
        t_charge.currency,
        logymd AS date_range,
        logymd AS date_range_end,
        logymd AS date_range_start,
        pay_channel,
        pay_channel_type,
        pay_type,
        product_id,
        product_money,
        t_charge.roleid,
        sub_pay_channel,
        sub_pay_channel_source,
        t_charge.zoneid
    FROM t_charge
)
SELECT
    dm_finance_role_zone_tz_di.product_money
FROM dm_finance_role_zone_tz_di;
```

## 各产品线实例
- [[actual_rate__mlbb__300317]] (scope=mlbb, dataset=300317, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[actual_rate__mlbb__300323]] (scope=mlbb, dataset=300323, 宽表=mt_dm.dm_finance_role_zone_tz_di)

## 元信息
- 分类: money · tier: 长尾