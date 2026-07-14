# DAU  `DAU`

**业务口径**: 有登录行为的去重玩家数

## 怎么算
**公式**: `day_cnt`

依赖的底层指标:
- [[day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_cnt`
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`

## 数据来源
- 宽表: [[realtime_login]], [[ads_gamebi_roger_primary_di]], [[realtime_basic_login]], [[ads_realtime_batch_data_di]]
- dataset: ['300018', '300364', '300401', '300144', '300225', '300272', '300300']  · 产品线 scope: ['mlbb', 'lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlcn', 'wefly_cn', 'wegame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **day_cnt** @ `mt_ads_realtime.realtime_basic_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_login:day_cnt`(D 层未自动解析,待补)
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

## 各产品线实例
- [[DAU__aoz__300401]] (scope=aoz, dataset=300401, 宽表=mt_ads_realtime.realtime_basic_login)
- [[DAU__lovania_cn__300364]] (scope=lovania_cn, dataset=300364, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[DAU__mlbb__300018]] (scope=mlbb, dataset=300018, 宽表=mt_ads_realtime.realtime_login)
- [[DAU__mlbb__300144]] (scope=mlbb, dataset=300144, 宽表=mt_ads_realtime.realtime_login)
- [[DAU__mlbb__300225]] (scope=mlbb, dataset=300225, 宽表=mt_ads_realtime.realtime_login)
- [[DAU__mlcn__300018]] (scope=mlcn, dataset=300018, 宽表=mt_ads_realtime.realtime_login)
- [[DAU__sgame_cn__300364]] (scope=sgame_cn, dataset=300364, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[DAU__tgame__300401]] (scope=tgame, dataset=300401, 宽表=mt_ads_realtime.realtime_basic_login)
- [[DAU__wefly5__300401]] (scope=wefly5, dataset=300401, 宽表=mt_ads_realtime.realtime_basic_login)
- [[DAU__wefly_cn__300272]] (scope=wefly_cn, dataset=300272, 宽表=mt_ads_realtime.realtime_login)
- [[DAU__wegame__300272]] (scope=wegame, dataset=300272, 宽表=mt_ads_realtime.realtime_login)
- [[DAU__zgame_cn__300300]] (scope=zgame_cn, dataset=300300, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: core-dau · tier: 长尾