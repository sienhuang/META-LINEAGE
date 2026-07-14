# active_cnt  `active_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `active_cnt`

依赖的底层指标:
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`
- [[pay_cnt]] (?) — `COALESCE(pay_cnt, 0) AS pay_cnt` [已确认] · 取数 `pay_cnt`

## 数据来源
- 宽表: [[ads_decismart_reten_ltv_di]], [[ads_gamebi_roger_primary_di]], [[realtime_login]], [[ads_mlbb_realtime_batch_data_di]], [[realtime_basic_login]], [[ads_decismart_rank_analysis]], [[realtime_basic_charge]], [[realtime_create_role]], [[realtime_charge]], [[realtime_charge_cnt]], [[ads_realtime_batch_data_di]]
- dataset: ['300218', '300196', '300197', '300400', '300366', '300266', '300263', '300264', '300406', '300117', '300409', '300198', '300276', '300275', '300265', '300291', '300292', '300293', '300351', '300353', '300300']  · 产品线 scope: ['lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlbb', 'wefly2', 'wefly_cn', 'wegame', 'xgame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **active_cnt** @ `mt_ads.ads_gamebi_roger_primary_di_us`
  - 跨任务血缘链(`mt_ads.ads_gamebi_roger_primary_di_us.active_cnt`):
    - d0 `mt_ads.ads_gamebi_roger_primary_di_us.active_cnt` ⇐ `subquery:job.100048520_0:final_insert_branch_1.active_cnt` [derived] `UNION_BRANCH_COLUMN[7]`
    - d0 `mt_ads.ads_gamebi_roger_primary_di_us.active_cnt` ⇐ `subquery:job.100048520_0:final_insert_branch_2.active_cnt` [derived] `UNION_BRANCH_COLUMN[7]`
    - d1 `subquery:job.100048520_0:final_insert_branch_1.active_cnt` ⇐ `mt_ads.ads_gamebi_roger_primary_di.active_cnt` [direct] `active_cnt /*	活跃玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100020886_2:subquery_2.active_cnt` [direct] `active_cnt /*	活跃玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100021029_2:subquery_8.active_cnt` [direct] `active_cnt /*	活跃玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100033108_0:t1.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100033187_0:b.active_days` [aggregated] `COALESCE(SUM(b.active_days), 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100037206_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100022588_2:b.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100025287_0:subquery_2.active_cnt` [direct] `active_cnt /*	活跃玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100030100_0:subquery_7.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100031072_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100031311_1:t2.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100037162_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100039140_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100041395_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100041408_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100041407_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100041406_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.active_cnt` ⇐ `subquery:job.100041409_1:a.active_cnt` [derived] `COALESCE(active_cnt, 0) AS active_cnt`
  - 整条链路 SQL:

```sql
WITH
ads_gamebi_roger_primary_di_us AS (
    SELECT
        active_cnt
    FROM final_insert_branch_1
)
SELECT
    ads_gamebi_roger_primary_di_us.active_cnt
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
- [[active_cnt__aoz__300266]] (scope=aoz, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__aoz__300263]] (scope=aoz, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__aoz__300264]] (scope=aoz, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__aoz__300406]] (scope=aoz, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[active_cnt__lovania_cn__300218]] (scope=lovania_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[active_cnt__lovania_cn__300196]] (scope=lovania_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__lovania_cn__300197]] (scope=lovania_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__lovania_cn__300400]] (scope=lovania_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[active_cnt__lovania_cn__300366]] (scope=lovania_cn, dataset=300366, 宽表=mt_ads_realtime.ads_mlbb_realtime_batch_data_di)
- [[active_cnt__mlbb__300117]] (scope=mlbb, dataset=300117, 宽表=test.ads_decismart_rank_analysis)
- [[active_cnt__mlbb__300409]] (scope=mlbb, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[active_cnt__sgame_cn__300218]] (scope=sgame_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[active_cnt__sgame_cn__300196]] (scope=sgame_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__sgame_cn__300197]] (scope=sgame_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__sgame_cn__300400]] (scope=sgame_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[active_cnt__sgame_cn__300366]] (scope=sgame_cn, dataset=300366, 宽表=mt_ads_realtime.ads_mlbb_realtime_batch_data_di)
- [[active_cnt__tgame__300266]] (scope=tgame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__tgame__300263]] (scope=tgame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__tgame__300264]] (scope=tgame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__tgame__300406]] (scope=tgame, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[active_cnt__wefly2__300263]] (scope=wefly2, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly2__300264]] (scope=wefly2, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly5__300266]] (scope=wefly5, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly5__300263]] (scope=wefly5, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly5__300264]] (scope=wefly5, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly5__300406]] (scope=wefly5, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[active_cnt__wefly_cn__300198]] (scope=wefly_cn, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly_cn__300218]] (scope=wefly_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[active_cnt__wefly_cn__300196]] (scope=wefly_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly_cn__300197]] (scope=wefly_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wefly_cn__300276]] (scope=wefly_cn, dataset=300276, 宽表=mt_ads_realtime.realtime_create_role)
- [[active_cnt__wefly_cn__300275]] (scope=wefly_cn, dataset=300275, 宽表=mt_ads_realtime.realtime_charge)
- [[active_cnt__wegame__300265]] (scope=wegame, dataset=300265, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wegame__300266]] (scope=wegame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wegame__300263]] (scope=wegame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wegame__300264]] (scope=wegame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__wegame__300291]] (scope=wegame, dataset=300291, 宽表=mt_ads_realtime.realtime_login)
- [[active_cnt__wegame__300292]] (scope=wegame, dataset=300292, 宽表=mt_ads_realtime.realtime_login)
- [[active_cnt__wegame__300293]] (scope=wegame, dataset=300293, 宽表=mt_ads_realtime.realtime_charge_cnt)
- [[active_cnt__xgame__300263]] (scope=xgame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__xgame__300264]] (scope=xgame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[active_cnt__zgame_cn__300351]] (scope=zgame_cn, dataset=300351, 宽表=—)
- [[active_cnt__zgame_cn__300353]] (scope=zgame_cn, dataset=300353, 宽表=—)
- [[active_cnt__zgame_cn__300300]] (scope=zgame_cn, dataset=300300, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: core-dau · tier: 长尾