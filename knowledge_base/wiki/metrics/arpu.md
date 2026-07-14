# arpu  `arpu`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pay_amt/100)/sum(active_cnt)`

依赖的底层指标:
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`
- [[pay_amt]] (?) — `UNION_BRANCH_COLUMN[10]` [已确认] · 取数 `pay_amt`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di]], [[ads_decismart_reten_ltv_di]], [[ads_mlbb_realtime_batch_data_di]], [[realtime_login]], [[realtime_basic_login]], [[realtime_basic_charge]], [[realtime_charge]], [[realtime_create_role]]
- dataset: ['300196', '300218', '300197', '300366', '300400', '300263', '300266', '300264', '300406', '300409', '300198', '300275', '300276', '300265', '300292']  · 产品线 scope: ['lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlbb', 'wefly2', 'wefly_cn', 'wegame', 'xgame']

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

## 各产品线实例
- [[arpu__aoz__300263]] (scope=aoz, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__aoz__300266]] (scope=aoz, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__aoz__300264]] (scope=aoz, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__aoz__300406]] (scope=aoz, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[arpu__lovania_cn__300196]] (scope=lovania_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__lovania_cn__300218]] (scope=lovania_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[arpu__lovania_cn__300197]] (scope=lovania_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__lovania_cn__300366]] (scope=lovania_cn, dataset=300366, 宽表=mt_ads_realtime.ads_mlbb_realtime_batch_data_di)
- [[arpu__lovania_cn__300400]] (scope=lovania_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[arpu__mlbb__300409]] (scope=mlbb, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[arpu__sgame_cn__300196]] (scope=sgame_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__sgame_cn__300218]] (scope=sgame_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[arpu__sgame_cn__300197]] (scope=sgame_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__sgame_cn__300366]] (scope=sgame_cn, dataset=300366, 宽表=mt_ads_realtime.ads_mlbb_realtime_batch_data_di)
- [[arpu__sgame_cn__300400]] (scope=sgame_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[arpu__tgame__300263]] (scope=tgame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__tgame__300266]] (scope=tgame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__tgame__300264]] (scope=tgame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__tgame__300406]] (scope=tgame, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[arpu__wefly2__300263]] (scope=wefly2, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly2__300264]] (scope=wefly2, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly5__300263]] (scope=wefly5, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly5__300266]] (scope=wefly5, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly5__300264]] (scope=wefly5, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly5__300406]] (scope=wefly5, dataset=300406, 宽表=mt_ads_realtime.realtime_basic_login)
- [[arpu__wefly_cn__300196]] (scope=wefly_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly_cn__300198]] (scope=wefly_cn, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly_cn__300218]] (scope=wefly_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[arpu__wefly_cn__300197]] (scope=wefly_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wefly_cn__300275]] (scope=wefly_cn, dataset=300275, 宽表=mt_ads_realtime.realtime_charge)
- [[arpu__wefly_cn__300276]] (scope=wefly_cn, dataset=300276, 宽表=mt_ads_realtime.realtime_create_role)
- [[arpu__wegame__300263]] (scope=wegame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wegame__300265]] (scope=wegame, dataset=300265, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wegame__300266]] (scope=wegame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wegame__300264]] (scope=wegame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__wegame__300292]] (scope=wegame, dataset=300292, 宽表=mt_ads_realtime.realtime_login)
- [[arpu__xgame__300263]] (scope=xgame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[arpu__xgame__300264]] (scope=xgame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)

## 元信息
- 分类: core-dau · tier: 长尾