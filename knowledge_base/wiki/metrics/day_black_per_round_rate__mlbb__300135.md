# day_black_per_round_rate · mlbb  `day_black_per_round_rate__mlbb__300135`

> 逻辑指标 [[day_black_per_round_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_black_cnt_sex)/sum(day_battle_cnt_sex)*100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_country_social_battle_exp_di  (dataset 300135)
- dataset SQL: `mysql://ba/data_set#300135`
- 维度: ['sex']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:1068