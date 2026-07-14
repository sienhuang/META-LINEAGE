# day_battle_cnt_total · mlbb  `day_battle_cnt_total__mlbb__300131`

> 逻辑指标 [[day_battle_cnt_total]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_battle_cnt_total)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_country_social_battle_exp_di  (dataset 300131)
- dataset SQL: `mysql://ba/data_set#300131`
- 维度: ['black_battle_type']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:930