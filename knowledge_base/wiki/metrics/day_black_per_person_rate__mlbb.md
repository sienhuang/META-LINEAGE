# day_black_per_person_rate · mlbb  `day_black_per_person_rate__mlbb`

> 逻辑指标 [[day_black_per_person_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_battle_black_num_country_fz)/sum(day_battle_num_country_fm)`
- **业务口径**: 处于开黑状态的人员及其相应战斗总场次 / 所有人员的战斗总场次 * 100%
- 宽表: mt_ads.ads_decismart_country_social_battle_exp_di  (dataset 300130)
- dataset SQL: `mysql://ba/data_set#300130`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/const.ts:164