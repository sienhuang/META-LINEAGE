# finish_rate  `finish_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `(avg(pay_amt)*avg(active_cnt_kpi))/(avg(active_cnt)*avg(pay_amt_kpi))*100`

依赖的底层指标:
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`
- [[active_cnt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_kpi`
- [[pay_amt]] (?) — `UNION_BRANCH_COLUMN[10]` [已确认] · 取数 `pay_amt`
- [[pay_amt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt_kpi`

## 数据来源
- 宽表: [[realtime_basic_charge]]
- dataset: ['300409']  · 产品线 scope: ['mlbb']

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

## 元信息
- 分类: core-dau · tier: 长尾