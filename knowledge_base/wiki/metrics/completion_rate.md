# completion_rate  `completion_rate`

**业务口径**: 累计新增用户数

## 怎么算
**公式**: `sum(register_cnt)/sum(register_cnt_kpi)*100`

依赖的底层指标:
- [[register_cnt]] (?) — `UNION_BRANCH_COLUMN[5]` [已确认] · 取数 `register_cnt`
- [[register_cnt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `register_cnt_kpi`
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`
- [[active_cnt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_kpi`
- [[pay_amt]] (?) — `UNION_BRANCH_COLUMN[10]` [已确认] · 取数 `pay_amt`
- [[pay_amt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt_kpi`
- [[arpu_kpi]] (?) — `⚠️待D层` [待补] · 取数 `arpu_kpi`
- [[pay_amt_daily]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt_daily`

## 数据来源
- 宽表: [[realtime_basic_charge]], [[realtime_basic_login]], [[realtime_basic_online]]
- dataset: ['300409', '300406', '300408']  · 产品线 scope: ['mlbb']

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
- **register_cnt_kpi** @ `mt_ads_realtime.realtime_basic_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_login:register_cnt_kpi`(D 层未自动解析,待补)
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
- **active_cnt_kpi** @ `mt_ads_realtime.realtime_basic_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_charge:active_cnt_kpi`(D 层未自动解析,待补)
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
- **pay_amt_kpi** @ `mt_ads_realtime.realtime_basic_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_charge:pay_amt_kpi`(D 层未自动解析,待补)
- **arpu_kpi** @ `mt_ads_realtime.realtime_basic_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_login:arpu_kpi`(D 层未自动解析,待补)
- **pay_amt_daily** @ `mt_ads_realtime.realtime_basic_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_login:pay_amt_daily`(D 层未自动解析,待补)

## 各产品线实例
- [[completion_rate__mlbb__300409]] (scope=mlbb, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[completion_rate__mlbb__300406]] (scope=mlbb, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[completion_rate__mlbb__300408]] (scope=mlbb, dataset=300408, 宽表=mt_ads_realtime.realtime_basic_online)

## 元信息
- 分类: register · tier: 长尾