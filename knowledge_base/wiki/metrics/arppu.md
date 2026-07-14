# arppu  `arppu`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pay_amt/100)/sum(pay_cnt)`

依赖的底层指标:
- [[pay_amt]] (?) — `UNION_BRANCH_COLUMN[10]` [已确认] · 取数 `pay_amt`
- [[pay_cnt]] (?) — `COALESCE(pay_cnt, 0) AS pay_cnt` [已确认] · 取数 `pay_cnt`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di]], [[ads_decismart_reten_ltv_di]], [[realtime_charge]], [[realtime_create_role]], [[realtime_charge_cnt]]
- dataset: ['300196', '300198', '300218', '300197', '300275', '300276', '300263', '300265', '300266', '300264', '300293']  · 产品线 scope: ['wefly_cn', 'wegame']

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
  - 整条链路 SQL:

```sql
WITH
ads_gamebi_roger_primary_di_us AS (
    SELECT
        pay_amt
    FROM final_insert_branch_1
)
SELECT
    ads_gamebi_roger_primary_di_us.pay_amt
FROM ads_gamebi_roger_primary_di_us;
```
- **pay_cnt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_pay_cube_di.pay_cnt`):
    - d0 `mt_ads.ads_decismart_pay_cube_di.pay_cnt` ⇐ `subquery:job.100025712_1:subquery_18.pay_cnt` [derived] `COALESCE(pay_cnt, 0) AS pay_cnt`
    - d0 `mt_ads.ads_decismart_pay_cube_di.pay_cnt` ⇐ `subquery:job.100026014_1:subquery_18.pay_cnt` [derived] `COALESCE(pay_cnt, 0) AS pay_cnt`
    - d1 `subquery:job.100025712_1:subquery_18.pay_cnt` ⇐ `cte:job.100025712_1:account_pay_di.roleid` [aggregated] `SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */`
    - d1 `subquery:job.100026014_1:subquery_18.pay_cnt` ⇐ `cte:job.100026014_1:account_pay_di.roleid` [aggregated] `SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */`
    - d2 `cte:job.100025712_1:account_pay_di.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_di.roleid` [direct] `roleid`
    - d2 `cte:job.100026014_1:account_pay_di.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_di.roleid` [direct] `roleid`
  - 整条链路 SQL:

```sql
WITH
dim_country_branch_1 AS (
    SELECT
        1 AS region_type
    FROM dim_country
    WHERE logymd = (SELECT MAX(logymd) FROM mt_dim.dim_country) /* 取最新 */
),
dim_country_branch_2 AS (
    SELECT
        0 AS region_type
    FROM dim_country
    WHERE logymd = (SELECT MAX(logymd) FROM mt_dim.dim_country) /* 取最新 */
),
dim_country AS (
    SELECT
        UNION_BRANCH_COLUMN[2]
    FROM dim_country_branch_1
),
dim_basic_country AS (
    SELECT
        COALESCE(con.region_type, 'unknwon') AS region_type
    FROM basic
    LEFT JOIN dim_country
        ON bas.country = con.country_code
),
account_pay_di AS (
    SELECT
        roleid
    FROM mt_dwm.dwm_charge_role_zone_di AS dwm_charge_role_zone_di
    WHERE logymd BETWEEN DATE_FORMAT('2026-05-31', 'yyyy-MM-01') AND LAST_DAY('2026-05-31') AND IF(logymd <= '2025-01-03', zoneid < 57000, zoneid > 0) AND before_tax_usd_amt > 0
    GROUP BY roleid
),
subquery_18 AS (
    SELECT
        SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */,
        basc.region_type
    FROM dim_basic_country
    LEFT JOIN account_pay_di
        ON basc.roleid = pay_di.roleid
    GROUP BY basc.region_type
),
ads_decismart_pay_cube_di AS (
    SELECT
        region_type AS definition_type,
        COALESCE(pay_cnt, 0) AS pay_cnt
    FROM subquery_18
)
SELECT
    ads_decismart_pay_cube_di.pay_cnt
FROM ads_decismart_pay_cube_di;
```

## 各产品线实例
- [[arppu__wefly_cn__300196]] (scope=wefly_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wefly_cn__300198]] (scope=wefly_cn, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wefly_cn__300218]] (scope=wefly_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[arppu__wefly_cn__300197]] (scope=wefly_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wefly_cn__300275]] (scope=wefly_cn, dataset=300275, 宽表=mt_ads_realtime.realtime_charge)
- [[arppu__wefly_cn__300276]] (scope=wefly_cn, dataset=300276, 宽表=mt_ads_realtime.realtime_create_role)
- [[arppu__wegame__300263]] (scope=wegame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wegame__300265]] (scope=wegame, dataset=300265, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wegame__300266]] (scope=wegame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wegame__300264]] (scope=wegame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arppu__wegame__300293]] (scope=wegame, dataset=300293, 宽表=mt_ads_realtime.realtime_charge_cnt)

## 元信息
- 分类: money · tier: 长尾