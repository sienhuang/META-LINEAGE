# day_battle_cnt_country_fm  `day_battle_cnt_country_fm`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_battle_cnt_country_fm)`

依赖的底层指标:
- [[day_battle_cnt_country_fm]] (?) — `day_battle_cnt_country_fm` [已确认] · 取数 `day_battle_cnt_country_fm`

## 数据来源
- 宽表: [[ads_decismart_country_social_battle_exp_di]]
- dataset: ['300130']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **day_battle_cnt_country_fm** @ `mt_ads.ads_decismart_country_social_battle_exp_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm`):
    - d0 `mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` [direct] `day_battle_cnt_country_fm`
    - d1 `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1_branch_1.day_battle_cnt_country_fm` [derived] `UNION_BRANCH_COLUMN[17]`
    - d1 `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1_branch_2.day_battle_cnt_country_fm` [derived] `UNION_BRANCH_COLUMN[17]`
    - d2 `subquery:job.100027494_1:t1_branch_1.day_battle_cnt_country_fm` ⇐ `mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm` [direct] `day_battle_cnt_country_fm`
    - d3 `mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` [direct] `day_battle_cnt_country_fm`
    - d4 `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1_branch_1.day_battle_cnt_country_fm` [derived] `UNION_BRANCH_COLUMN[17]`
    - d4 `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1_branch_2.day_battle_cnt_country_fm` [derived] `UNION_BRANCH_COLUMN[17]`
    - d5 `subquery:job.100027494_1:t1_branch_1.day_battle_cnt_country_fm` ⇐ `mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm` [direct] `day_battle_cnt_country_fm`
    - d6 `mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` [direct] `day_battle_cnt_country_fm`
    - d7 `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1_branch_1.day_battle_cnt_country_fm` [derived] `UNION_BRANCH_COLUMN[17]`
    - d7 `subquery:job.100027494_1:t1.day_battle_cnt_country_fm` ⇐ `subquery:job.100027494_1:t1_branch_2.day_battle_cnt_country_fm` [derived] `UNION_BRANCH_COLUMN[17]`
    - d8 `subquery:job.100027494_1:t1_branch_1.day_battle_cnt_country_fm` ⇐ `mt_ads.ads_decismart_country_social_battle_exp_di.day_battle_cnt_country_fm` [direct] `day_battle_cnt_country_fm`

## 元信息
- 分类: other · tier: 长尾