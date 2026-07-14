# day_black_per_round_rate · mlbb  `day_black_per_round_rate__mlbb__300130`

> 逻辑指标 [[day_black_per_round_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_black_cnt_country_fz)/sum(day_battle_cnt_country_fm)*100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_country_social_battle_exp_di  (dataset 300130)
- dataset SQL: `mysql://ba/data_set#300130`
- 维度: ['region']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:861