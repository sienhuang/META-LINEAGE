# 深度AI回退率  `深度AI回退率`

**业务口径**: (每个battletime - aihooktime > 10的AI人次) / 需要深度AI接管的人次（排除58中的主动拉起和主动回退） * 100%；
数据起始日期为2024-04-25。

## 怎么算
**公式**: `sum(deep_ai_rollback_fz)/sum(deep_ai_rollback_fm)`

依赖的底层指标:
- [[deep_ai_rollback_fm]] (?) — `deep_ai_rollback_fm` [已确认] · 取数 `deep_ai_rollback_fm`
- [[deep_ai_rollback_fz]] (?) — `deep_ai_rollback_fz` [已确认] · 取数 `deep_ai_rollback_fz`

## 数据来源
- 宽表: [[ads_decismart_exp_match_battle_di]]
- dataset: ['300342']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **deep_ai_rollback_fm** @ `mt_ads.ads_decismart_exp_match_battle_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fm`):
    - d0 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` [direct] `deep_ai_rollback_fm`
    - d0 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fm` ⇐ `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fm` [direct] `deep_ai_rollback_fm`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_1.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_2.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_3.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_4.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_5.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_6.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d1 `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fm` ⇐ `subquery:job.100044700_0:subquery_6_branch_1.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[22]`
    - d1 `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fm` ⇐ `subquery:job.100044700_0:subquery_6_branch_2.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[22]`
    - d1 `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fm` ⇐ `subquery:job.100044700_0:subquery_6_branch_3.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[22]`
    - d2 `subquery:job.100044544_0:subquery_19_branch_4.deep_ai_rollback_fm` ⇐ `cte:job.100044544_0:battleai_end.deep_ai_rollback_fm` [direct] `deep_ai_rollback_fm`
    - d2 `subquery:job.100044700_0:subquery_6_branch_1.deep_ai_rollback_fm` ⇐ `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fm` [direct] `deep_ai_rollback_fm`
    - d3 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` [direct] `deep_ai_rollback_fm`
    - d3 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fm` ⇐ `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fm` [direct] `deep_ai_rollback_fm`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_1.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_2.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_3.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_4.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fm` ⇐ `subquery:job.100044544_0:subquery_19_branch_5.deep_ai_rollback_fm` [derived] `UNION_BRANCH_COLUMN[12]`
- **deep_ai_rollback_fz** @ `mt_ads.ads_decismart_exp_match_battle_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fz`):
    - d0 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` [direct] `deep_ai_rollback_fz`
    - d0 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fz` ⇐ `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fz` [direct] `deep_ai_rollback_fz`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_1.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_2.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_3.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_4.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_5.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d1 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_6.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d1 `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fz` ⇐ `subquery:job.100044700_0:subquery_6_branch_1.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[21]`
    - d1 `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fz` ⇐ `subquery:job.100044700_0:subquery_6_branch_2.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[21]`
    - d1 `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fz` ⇐ `subquery:job.100044700_0:subquery_6_branch_3.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[21]`
    - d2 `subquery:job.100044544_0:subquery_19_branch_4.deep_ai_rollback_fz` ⇐ `cte:job.100044544_0:battleai_end.deep_ai_rollback_fz` [direct] `deep_ai_rollback_fz`
    - d2 `subquery:job.100044700_0:subquery_6_branch_1.deep_ai_rollback_fz` ⇐ `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fz` [direct] `deep_ai_rollback_fz`
    - d3 `cte:job.100044544_0:battleai_end.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:t1.isreturn` [aggregated] `COUNT(CASE WHEN t1.isreturn = 1 THEN 1 ELSE NULL END) AS deep_ai_rollback_fz`
    - d3 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` [direct] `deep_ai_rollback_fz`
    - d3 `mt_ads.ads_decismart_exp_match_battle_di.deep_ai_rollback_fz` ⇐ `subquery:job.100044700_0:subquery_6.deep_ai_rollback_fz` [direct] `deep_ai_rollback_fz`
    - d4 `subquery:job.100044544_0:t1.isreturn` ⇐ `ml_ods.battleserver_battleai_end.battletime` [derived] `IF((battletime - aihooktime) > 10, 1, 0) AS isreturn`
    - d4 `subquery:job.100044544_0:t1.isreturn` ⇐ `ml_ods.battleserver_battleai_end.aihooktime` [derived] `IF((battletime - aihooktime) > 10, 1, 0) AS isreturn`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_1.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`
    - d4 `subquery:job.100044544_0:subquery_19.deep_ai_rollback_fz` ⇐ `subquery:job.100044544_0:subquery_19_branch_2.deep_ai_rollback_fz` [derived] `UNION_BRANCH_COLUMN[11]`

## 元信息
- 分类: other · tier: 长尾