# register_cnt  `register_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `register_cnt`

依赖的底层指标:
- [[register_cnt]] (?) — `UNION_BRANCH_COLUMN[5]` [已确认] · 取数 `register_cnt`

## 数据来源
- 宽表: [[ads_decismart_reten_ltv_di]], [[realtime_login]], [[ads_gamebi_roger_primary_di]], [[realtime_basic_charge]], [[realtime_create_role]], [[ads_realtime_batch_data_di]]
- dataset: ['300218', '300400', '300266', '300409', '300198', '300276', '300265', '300351', '300353', '300300']  · 产品线 scope: ['lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlbb', 'wefly_cn', 'wegame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **register_cnt** @ `mt_ads.ads_gamebi_roger_primary_di_us`
  - 跨任务血缘链(`mt_ads.ads_gamebi_roger_primary_di_us.register_cnt`):
    - d0 `mt_ads.ads_gamebi_roger_primary_di_us.register_cnt` ⇐ `subquery:job.100048520_0:final_insert_branch_1.register_cnt` [derived] `UNION_BRANCH_COLUMN[5]`
    - d0 `mt_ads.ads_gamebi_roger_primary_di_us.register_cnt` ⇐ `subquery:job.100048520_0:final_insert_branch_2.register_cnt` [derived] `UNION_BRANCH_COLUMN[5]`
    - d1 `subquery:job.100048520_0:final_insert_branch_1.register_cnt` ⇐ `mt_ads.ads_gamebi_roger_primary_di.register_cnt` [direct] `register_cnt /*	新增玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100020886_2:subquery_2.register_cnt` [direct] `register_cnt /*	新增玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100021029_2:subquery_8.register_cnt` [direct] `register_cnt /*	新增玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100033108_0:t1.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100037206_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100022588_2:b.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100025287_0:subquery_2.register_cnt` [direct] `register_cnt /*	新增玩家数 */`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100030100_0:subquery_7.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100031072_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100031311_1:t2.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100037162_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100039140_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100041395_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100041408_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100041407_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100041406_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100041409_1:a.register_cnt` [derived] `COALESCE(register_cnt, 0) AS register_cnt`
    - d2 `mt_ads.ads_gamebi_roger_primary_di.register_cnt` ⇐ `subquery:job.100052167_1:t3.register_cnt` [derived] `COALESCE(t3.register_cnt, 0) AS register_cnt`

## 各产品线实例
- [[register_cnt__aoz__300266]] (scope=aoz, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[register_cnt__lovania_cn__300218]] (scope=lovania_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[register_cnt__lovania_cn__300400]] (scope=lovania_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[register_cnt__mlbb__300409]] (scope=mlbb, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[register_cnt__sgame_cn__300218]] (scope=sgame_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[register_cnt__sgame_cn__300400]] (scope=sgame_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[register_cnt__tgame__300266]] (scope=tgame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[register_cnt__wefly5__300266]] (scope=wefly5, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[register_cnt__wefly_cn__300198]] (scope=wefly_cn, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[register_cnt__wefly_cn__300218]] (scope=wefly_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[register_cnt__wefly_cn__300276]] (scope=wefly_cn, dataset=300276, 宽表=mt_ads_realtime.realtime_create_role)
- [[register_cnt__wegame__300265]] (scope=wegame, dataset=300265, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[register_cnt__wegame__300266]] (scope=wegame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[register_cnt__zgame_cn__300351]] (scope=zgame_cn, dataset=300351, 宽表=—)
- [[register_cnt__zgame_cn__300353]] (scope=zgame_cn, dataset=300353, 宽表=—)
- [[register_cnt__zgame_cn__300300]] (scope=zgame_cn, dataset=300300, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: register · tier: 长尾