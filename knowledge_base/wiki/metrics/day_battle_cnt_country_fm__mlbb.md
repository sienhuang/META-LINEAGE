# day_battle_cnt_country_fm · mlbb  `day_battle_cnt_country_fm__mlbb`

> 逻辑指标 [[day_battle_cnt_country_fm]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_battle_cnt_country_fm)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_country_social_battle_exp_di  (dataset 300130)
- dataset SQL: `mysql://ba/data_set#300130`
- 维度: ['country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:1600