# 日均DAU  `日均DAU`

**业务口径**: (所选日期按天活跃玩家数进行累计)/(所选日期的总天数)

## 怎么算
**公式**: `active_cnt`

依赖的底层指标:
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di_us]], [[ads_gamebi_roger_primary_di]]
- dataset: ['300368', '300005', '300161', '200008', '300246', '300195', '300255', '300350']  · 产品线 scope: ['mlbb', 'lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlcn', 'wefly_cn', 'zgame_cn']

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

## 各产品线实例
- [[日均DAU__aoz__300005]] (scope=aoz, dataset=300005, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__lovania_cn__300005]] (scope=lovania_cn, dataset=300005, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__mlbb__300368]] (scope=mlbb, dataset=300368, 宽表=mt_ads.ads_gamebi_roger_primary_di_us)
- [[日均DAU__mlbb__300005]] (scope=mlbb, dataset=300005, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__mlbb__300161]] (scope=mlbb, dataset=300161, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__mlbb__300246]] (scope=mlbb, dataset=300246, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__mlbb__300255]] (scope=mlbb, dataset=300255, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__mlcn__200008]] (scope=mlcn, dataset=200008, 宽表=—)
- [[日均DAU__sgame_cn__300005]] (scope=sgame_cn, dataset=300005, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__tgame__300005]] (scope=tgame, dataset=300005, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__wefly5__300005]] (scope=wefly5, dataset=300005, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[日均DAU__wefly_cn__300195]] (scope=wefly_cn, dataset=300195, 宽表=—)
- [[日均DAU__zgame_cn__300350]] (scope=zgame_cn, dataset=300350, 宽表=—)

## 元信息
- 分类: core-dau · tier: 长尾