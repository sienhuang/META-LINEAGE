# acu  `acu`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `acu`

依赖的底层指标:
- [[acu]] (?) — `⚠️待D层` [草稿] · 取数 `acu`

## 数据来源
- 宽表: [[realtime_online_cube_view]], [[realtime_login]], [[realtime_basic_charge]], [[realtime_basic_create_role]], [[ads_gamebi_roger_primary_cube_di]], [[realtime_basic_online]], [[realtime_online_cube_view_us_test]], [[realtime_online_cube_view_mla]], [[realtime_online_nova_cube_view]], [[realtime_online_cube_view_zgame]]
- dataset: ['300371', '300041', '300355', '300400', '300405', '300404', '300008', '300413', '300414', '300408', '300412', '300040', '300162', '300174', '300175', '200013', '300188', '300229', '300235', '300148', '300151']  · 产品线 scope: ['mlbb', 'lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlcn', 'wefly2', 'xgame']

## 字段生成逻辑(D 层)
- **acu** @ `mt_ads.ads_gamebi_roger_primary_cube_di`
  - 跨任务血缘链(`mt_ads.ads_gamebi_roger_primary_cube_di.acu`):
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100021369_1:online_cube.acu` [derived] `COALESCE(acu, 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100022737_1:online_cube.acu` [derived] `COALESCE(acu, 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100030075_1:online_cube.acu` [derived] `COALESCE(ROUND(acu, 0), 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100031394_1:online_cube.acu` [derived] `COALESCE(ROUND(acu, 0), 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100037249_1:online_cube.acu` [derived] `COALESCE(acu, 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100031163_1:online_cube.acu` [derived] `COALESCE(acu, 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100033079_1:online_cube.acu` [derived] `COALESCE(ROUND(acu, 0), 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100037278_1:online_cube.acu` [derived] `COALESCE(acu, 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100051061_1:online_cube.acu` [derived] `COALESCE(ROUND(acu, 0), 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100052839_0:online_cube.acu` [derived] `COALESCE(ROUND(acu, 0), 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100052169_0:online_cube.acu` [derived] `COALESCE(ROUND(acu, 0), 0) AS acu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.acu` ⇐ `cte:job.100048777_0:online_cube.acu` [derived] `COALESCE(acu, 0) AS acu`
    - d1 `cte:job.100021369_1:online_cube.acu` ⇐ `subquery:job.100021369_1:online_cube_branch_1.acu` [derived] `UNION_BRANCH_COLUMN[5]`
    - d1 `cte:job.100021369_1:online_cube.acu` ⇐ `subquery:job.100021369_1:online_cube_branch_2.acu` [derived] `UNION_BRANCH_COLUMN[5]`
    - d1 `cte:job.100022737_1:online_cube.acu` ⇐ `subquery:job.100022737_1:online_cube_branch_1.acu` [derived] `UNION_BRANCH_COLUMN[6]`
    - d1 `cte:job.100022737_1:online_cube.acu` ⇐ `subquery:job.100022737_1:online_cube_branch_2.acu` [derived] `UNION_BRANCH_COLUMN[6]`
    - d1 `cte:job.100030075_1:online_cube.acu` ⇐ `subquery:job.100030075_1:subquery_9.online_num` [aggregated] `AVG(online_num) AS acu`
    - d1 `cte:job.100031394_1:online_cube.acu` ⇐ `subquery:job.100031394_1:subquery_9.online_num` [aggregated] `AVG(online_num) AS acu`
    - d1 `cte:job.100037249_1:online_cube.acu` ⇐ `subquery:job.100037249_1:online_cube_branch_1.acu` [derived] `UNION_BRANCH_COLUMN[6]`
    - d1 `cte:job.100037249_1:online_cube.acu` ⇐ `subquery:job.100037249_1:online_cube_branch_2.acu` [derived] `UNION_BRANCH_COLUMN[6]`
  - 整条链路 SQL:

```sql
WITH
real_country_online AS (
    SELECT
        day_point AS div_time,
        online_num,
        vp_online_num
    FROM xgame_ods.connserver_t_real_os_country_online AS connserver_t_real_os_country_online
    WHERE logymd = '2026-05-31'
),
dim_country AS (
    SELECT
        country_code AS country,
        region,
        definition_type AS region_type
    FROM mt_dim.dim_gamebi_country AS dim_gamebi_country
    WHERE logymd = IF('2026-05-31' <= '2026-02-07', '2026-02-07', '2026-05-31') AND appname = 'xgame'
),
subquery_6 AS (
    SELECT
        con.country,
        lin.div_time,
        SUM(COALESCE(online_num, 0) - COALESCE(vp_online_num, 0)) AS online_num /* 在线人数 */,
        con.region,
        con.region_type
    FROM dim_country
    LEFT JOIN real_country_online
        ON con.country = lin.country
    GROUP BY con.region_type, con.region, con.country, lin.div_time
),
online_cube AS (
    SELECT
        ROUND(SUM(online_num) / 288) AS acu,
        country,
        MAX(online_num) AS pcu,
        region,
        region_type
    FROM subquery_6
    GROUP BY region_type, region, country
),
ads_gamebi_roger_primary_cube_di AS (
    SELECT
        COALESCE(acu, 0) AS acu,
        COALESCE(country, 'all') AS country,
        region_type AS definition_type,
        CONCAT('(', CONCAT_WS(',', IF(NOT country IS NULL, 'country', NULL), IF(NOT region IS NULL, 'region', NULL)), ')') AS grouping_name,
        COALESCE(pcu, 0) AS pcu,
        COALESCE(region, 'all') AS region
    FROM online_cube
)
SELECT
    ads_gamebi_roger_primary_cube_di.acu
FROM ads_gamebi_roger_primary_cube_di;
```

## 各产品线实例
- [[acu__aoz__300008]] (scope=aoz, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[acu__aoz__300413]] (scope=aoz, dataset=300413, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__aoz__300414]] (scope=aoz, dataset=300414, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__aoz__300408]] (scope=aoz, dataset=300408, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__aoz__300412]] (scope=aoz, dataset=300412, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__lovania_cn__na]] (scope=lovania_cn, dataset=None, 宽表=—)
- [[acu__lovania_cn__300355]] (scope=lovania_cn, dataset=300355, 宽表=—)
- [[acu__lovania_cn__300400]] (scope=lovania_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[acu__lovania_cn__300405]] (scope=lovania_cn, dataset=300405, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[acu__lovania_cn__300404]] (scope=lovania_cn, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[acu__mlbb__300371]] (scope=mlbb, dataset=300371, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[acu__mlbb__300041]] (scope=mlbb, dataset=300041, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[acu__mlbb__300040]] (scope=mlbb, dataset=300040, 宽表=mt_ads_realtime.realtime_online_cube_view_us_test)
- [[acu__mlbb__300162]] (scope=mlbb, dataset=300162, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[acu__mlbb__300174]] (scope=mlbb, dataset=300174, 宽表=mt_ads_realtime.realtime_online_cube_view_mla)
- [[acu__mlbb__300175]] (scope=mlbb, dataset=300175, 宽表=mt_ads_realtime.realtime_online_cube_view_mla)
- [[acu__mlbb__300008]] (scope=mlbb, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[acu__mlbb__300188]] (scope=mlbb, dataset=300188, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[acu__mlbb__300229]] (scope=mlbb, dataset=300229, 宽表=mt_ads_realtime.realtime_online_nova_cube_view)
- [[acu__mlbb__300235]] (scope=mlbb, dataset=300235, 宽表=mt_ads_realtime.realtime_online_nova_cube_view)
- [[acu__mlbb__300148]] (scope=mlbb, dataset=300148, 宽表=mt_ads_realtime.realtime_online_cube_view_zgame)
- [[acu__mlbb__300151]] (scope=mlbb, dataset=300151, 宽表=mt_ads_realtime.realtime_online_cube_view_zgame)
- [[acu__mlcn__200013]] (scope=mlcn, dataset=200013, 宽表=—)
- [[acu__mlcn__300041]] (scope=mlcn, dataset=300041, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[acu__sgame_cn__na]] (scope=sgame_cn, dataset=None, 宽表=—)
- [[acu__sgame_cn__300355]] (scope=sgame_cn, dataset=300355, 宽表=—)
- [[acu__sgame_cn__300400]] (scope=sgame_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[acu__sgame_cn__300405]] (scope=sgame_cn, dataset=300405, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[acu__sgame_cn__300404]] (scope=sgame_cn, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[acu__tgame__300008]] (scope=tgame, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[acu__tgame__300413]] (scope=tgame, dataset=300413, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__tgame__300414]] (scope=tgame, dataset=300414, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__tgame__300408]] (scope=tgame, dataset=300408, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__tgame__300412]] (scope=tgame, dataset=300412, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__wefly2__300008]] (scope=wefly2, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[acu__wefly5__300008]] (scope=wefly5, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[acu__wefly5__300413]] (scope=wefly5, dataset=300413, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__wefly5__300414]] (scope=wefly5, dataset=300414, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__wefly5__300408]] (scope=wefly5, dataset=300408, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__wefly5__300412]] (scope=wefly5, dataset=300412, 宽表=mt_ads_realtime.realtime_basic_online)
- [[acu__xgame__300008]] (scope=xgame, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)

## 元信息
- 分类: core-dau · tier: 长尾