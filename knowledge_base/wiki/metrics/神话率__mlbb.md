# 神话率 · mlbb  `神话率__mlbb`

> 逻辑指标 [[神话率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(myth_user_cnt_fz)/sum(myth_user_cnt_total_fm)`
- **业务口径**: 当日达成神话及以上段位的玩家数 / 活跃玩家数  * 100%
- 宽表: mt_ads.ads_decismart_country_social_battle_exp_di  (dataset 300130)
- dataset SQL: `mysql://ba/data_set#300130`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1007