# day_battle_cnt_age · mlbb  `day_battle_cnt_age__mlbb__300133`

> 逻辑指标 [[day_battle_cnt_age]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_battle_cnt_age)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_country_social_battle_exp_di  (dataset 300133)
- dataset SQL: `mysql://ba/data_set#300133`
- 维度: ['age_group']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:999