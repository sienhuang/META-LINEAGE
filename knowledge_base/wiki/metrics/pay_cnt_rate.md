# pay_cnt_rate  `pay_cnt_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pay_cnt)/sum(active_cnt)`

依赖的底层指标:
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`
- [[pay_cnt]] (?) — `COALESCE(pay_cnt, 0) AS pay_cnt` [已确认] · 取数 `pay_cnt`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di]], [[ads_decismart_reten_ltv_di]], [[realtime_charge]], [[realtime_create_role]], [[realtime_login]], [[ads_realtime_batch_data_di]]
- dataset: ['300196', '300198', '300218', '300197', '300275', '300276', '300263', '300265', '300266', '300264', '300291', '300300']  · 产品线 scope: ['wefly_cn', 'wegame', 'zgame_cn']

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
- **pay_cnt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_pay_cube_di.pay_cnt`):
    - d0 `mt_ads.ads_decismart_pay_cube_di.pay_cnt` ⇐ `subquery:job.100025712_1:subquery_18.pay_cnt` [derived] `COALESCE(pay_cnt, 0) AS pay_cnt`
    - d0 `mt_ads.ads_decismart_pay_cube_di.pay_cnt` ⇐ `subquery:job.100026014_1:subquery_18.pay_cnt` [derived] `COALESCE(pay_cnt, 0) AS pay_cnt`
    - d1 `subquery:job.100025712_1:subquery_18.pay_cnt` ⇐ `cte:job.100025712_1:account_pay_di.roleid` [aggregated] `SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */`
    - d1 `subquery:job.100026014_1:subquery_18.pay_cnt` ⇐ `cte:job.100026014_1:account_pay_di.roleid` [aggregated] `SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */`
    - d2 `cte:job.100025712_1:account_pay_di.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_di.roleid` [direct] `roleid`
    - d2 `cte:job.100026014_1:account_pay_di.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_di.roleid` [direct] `roleid`

## 各产品线实例
- [[pay_cnt_rate__wefly_cn__300196]] (scope=wefly_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wefly_cn__300198]] (scope=wefly_cn, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wefly_cn__300218]] (scope=wefly_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[pay_cnt_rate__wefly_cn__300197]] (scope=wefly_cn, dataset=300197, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wefly_cn__300275]] (scope=wefly_cn, dataset=300275, 宽表=mt_ads_realtime.realtime_charge)
- [[pay_cnt_rate__wefly_cn__300276]] (scope=wefly_cn, dataset=300276, 宽表=mt_ads_realtime.realtime_create_role)
- [[pay_cnt_rate__wegame__300263]] (scope=wegame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wegame__300265]] (scope=wegame, dataset=300265, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wegame__300266]] (scope=wegame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wegame__300264]] (scope=wegame, dataset=300264, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt_rate__wegame__300291]] (scope=wegame, dataset=300291, 宽表=mt_ads_realtime.realtime_login)
- [[pay_cnt_rate__zgame_cn__300300]] (scope=zgame_cn, dataset=300300, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: core-dau · tier: 长尾