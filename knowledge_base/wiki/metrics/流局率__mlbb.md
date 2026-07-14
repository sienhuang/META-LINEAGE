# 流局率 · mlbb  `流局率__mlbb`

> 逻辑指标 [[流局率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_invaild_battle_cnt_fz)/sum(day_invaild_battle_cnt_fm)`
- **业务口径**: 今日流局的对局数 / 今日总局数 * 100%
- 宽表: mt_ads.ads_decismart_country_social_battle_exp_di  (dataset 300140)
- dataset SQL: `mysql://ba/data_set#300140`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:119