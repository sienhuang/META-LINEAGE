# PCU  `PCU`

**业务口径**: PCU: 最大同时在线玩家数
ACU: 平均同时在线玩家数

## 怎么算
**公式**: `pcu`

依赖的底层指标:
- [[pcu]] (?) — `⚠️待D层` [草稿] · 取数 `pcu`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_cube_di]], [[realtime_login]], [[ads_decismart_online_di]], [[realtime_zone_online]]
- dataset: ['300008', '300200', '200011', '300280', '300260', '300295', '300355']  · 产品线 scope: ['mlbb', 'mcgg', 'mlcn', 'wefly_cn', 'wegame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **pcu** @ `mt_ads.ads_gamebi_roger_primary_cube_di`
  - 跨任务血缘链(`mt_ads.ads_gamebi_roger_primary_cube_di.pcu`):
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100021369_1:online_cube.pcu` [derived] `COALESCE(pcu, 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100022737_1:online_cube.pcu` [derived] `COALESCE(pcu, 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100030075_1:online_cube.pcu` [derived] `COALESCE(ROUND(pcu, 0), 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100031394_1:online_cube.pcu` [derived] `COALESCE(ROUND(pcu, 0), 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100037249_1:online_cube.pcu` [derived] `COALESCE(pcu, 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100031163_1:online_cube.pcu` [derived] `COALESCE(pcu, 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100033079_1:online_cube.pcu` [derived] `COALESCE(ROUND(pcu, 0), 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100037278_1:online_cube.pcu` [derived] `COALESCE(pcu, 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100051061_1:online_cube.pcu` [derived] `COALESCE(ROUND(pcu, 0), 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100052839_0:online_cube.pcu` [derived] `COALESCE(ROUND(pcu, 0), 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100052169_0:online_cube.pcu` [derived] `COALESCE(ROUND(pcu, 0), 0) AS pcu`
    - d0 `mt_ads.ads_gamebi_roger_primary_cube_di.pcu` ⇐ `cte:job.100048777_0:online_cube.pcu` [derived] `COALESCE(pcu, 0) AS pcu`
    - d1 `cte:job.100021369_1:online_cube.pcu` ⇐ `subquery:job.100021369_1:online_cube_branch_1.pcu` [derived] `UNION_BRANCH_COLUMN[4]`
    - d1 `cte:job.100021369_1:online_cube.pcu` ⇐ `subquery:job.100021369_1:online_cube_branch_2.pcu` [derived] `UNION_BRANCH_COLUMN[4]`
    - d1 `cte:job.100022737_1:online_cube.pcu` ⇐ `subquery:job.100022737_1:online_cube_branch_1.pcu` [derived] `UNION_BRANCH_COLUMN[5]`
    - d1 `cte:job.100022737_1:online_cube.pcu` ⇐ `subquery:job.100022737_1:online_cube_branch_2.pcu` [derived] `UNION_BRANCH_COLUMN[5]`
    - d1 `cte:job.100030075_1:online_cube.pcu` ⇐ `subquery:job.100030075_1:subquery_9.online_num` [aggregated] `MAX(online_num) AS pcu`
    - d1 `cte:job.100031394_1:online_cube.pcu` ⇐ `subquery:job.100031394_1:subquery_9.online_num` [aggregated] `MAX(online_num) AS pcu`
    - d1 `cte:job.100037249_1:online_cube.pcu` ⇐ `subquery:job.100037249_1:online_cube_branch_1.pcu` [derived] `UNION_BRANCH_COLUMN[5]`
    - d1 `cte:job.100037249_1:online_cube.pcu` ⇐ `subquery:job.100037249_1:online_cube_branch_2.pcu` [derived] `UNION_BRANCH_COLUMN[5]`
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
    ads_gamebi_roger_primary_cube_di.pcu
FROM ads_gamebi_roger_primary_cube_di;
```

## 各产品线实例
- [[PCU__mcgg__300200]] (scope=mcgg, dataset=300200, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[PCU__mlbb__300008]] (scope=mlbb, dataset=300008, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[PCU__mlcn__200011]] (scope=mlcn, dataset=200011, 宽表=—)
- [[PCU__wefly_cn__300200]] (scope=wefly_cn, dataset=300200, 宽表=mt_ads.ads_gamebi_roger_primary_cube_di)
- [[PCU__wefly_cn__300280]] (scope=wefly_cn, dataset=300280, 宽表=mt_ads_realtime.realtime_login)
- [[PCU__wegame__300260]] (scope=wegame, dataset=300260, 宽表=mt_ads.ads_decismart_online_di)
- [[PCU__wegame__300295]] (scope=wegame, dataset=300295, 宽表=mt_ads_realtime.realtime_zone_online)
- [[PCU__zgame_cn__300355]] (scope=zgame_cn, dataset=300355, 宽表=—)

## 元信息
- 分类: core-dau · tier: 长尾