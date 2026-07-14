# online_dur_per_person  `online_dur_per_person`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(online_dur)/sum(active_cnt)/60`

依赖的底层指标:
- [[active_cnt]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `active_cnt`
- [[online_dur]] (?) — `⚠️待D层` [草稿] · 取数 `online_dur`
- [[ol_dur_user_type_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_user_type_arr`
- [[ol_dur_user_type_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_user_type_role_cnt_arr`
- [[ol_dur_age_group_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_arr`
- [[ol_dur_age_group_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_role_cnt_arr`
- [[ol_dur_sex_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_arr`
- [[ol_dur_sex_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_role_cnt_arr`

## 数据来源
- 宽表: [[ads_decismart_rank_analysis]]
- dataset: ['300117', '300118', '300120', '300122']  · 产品线 scope: ['mlbb']

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
- **online_dur** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 跨任务血缘链(`mt_ads.ads_gamebi_roger_primary_di.online_dur`):
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100020886_2:subquery_2.online_dur` [direct] `online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100033108_0:t1.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100022588_2:b.online_time` [derived] `COALESCE(b.online_time, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100025287_0:subquery_2.online_dur` [direct] `online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100030100_0:subquery_7.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100031072_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100031311_1:t2.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100039140_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100041395_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100041408_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100041407_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100041406_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100041409_1:a.online_dur` [derived] `COALESCE(online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100052167_1:t3.online_dur` [derived] `COALESCE(t3.online_dur, 0) AS online_dur`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100052824_0:t3.online_dur` [derived] `COALESCE(t3.online_dur, 0) AS online_dur`
    - d0 `mt_ads.ads_gamebi_roger_primary_di.online_dur` ⇐ `subquery:job.100050909_1:t3.online_dur` [derived] `COALESCE(t3.online_dur, 0) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d1 `subquery:job.100020886_2:subquery_2.online_dur` ⇐ `subquery:job.100020886_2:subquery_3.online_dur` [aggregated] `COALESCE(SUM(online_dur), 0) AS online_dur`
    - d1 `subquery:job.100033108_0:t1.online_dur` ⇐ `cte:job.100033108_0:tmp_tbl.online_dur` [aggregated] `SUM(online_dur) AS online_dur /*	当日玩家总在线时长(单位：s) */`
    - d1 `subquery:job.100022588_2:b.online_time` ⇐ `subquery:job.100022588_2:subquery_5.online_time` [aggregated] `COALESCE(SUM(online_time), 0) AS online_time`
    - d1 `subquery:job.100025287_0:subquery_2.online_dur` ⇐ `subquery:job.100025287_0:subquery_3.online_dur` [aggregated] `COALESCE(SUM(online_dur), 0) AS online_dur`
- **ol_dur_user_type_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_user_type_arr`(D 层未自动解析,待补)
- **ol_dur_user_type_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_user_type_role_cnt_arr`(D 层未自动解析,待补)
- **ol_dur_age_group_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_age_group_arr`(D 层未自动解析,待补)
- **ol_dur_age_group_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_age_group_role_cnt_arr`(D 层未自动解析,待补)
- **ol_dur_sex_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_sex_arr`(D 层未自动解析,待补)
- **ol_dur_sex_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_sex_role_cnt_arr`(D 层未自动解析,待补)

## 各产品线实例
- [[online_dur_per_person__mlbb__300117]] (scope=mlbb, dataset=300117, 宽表=test.ads_decismart_rank_analysis)
- [[online_dur_per_person__mlbb__300118]] (scope=mlbb, dataset=300118, 宽表=test.ads_decismart_rank_analysis)
- [[online_dur_per_person__mlbb__300120]] (scope=mlbb, dataset=300120, 宽表=test.ads_decismart_rank_analysis)
- [[online_dur_per_person__mlbb__300122]] (scope=mlbb, dataset=300122, 宽表=test.ads_decismart_rank_analysis)

## 元信息
- 分类: core-dau · tier: 长尾