# 温暖关投放率 · mlbb  `温暖关投放率__mlbb`

> 逻辑指标 [[温暖关投放率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(battle_warmcnt_fz)/sum(total_battle_cnt_warm_fm)`
- **业务口径**: 今日是温暖关的对局数 / 总对局数 * 100%；
数据起始日期为2023-09-19。
- 宽表: mt_ads.ads_decismart_exp_match_battle_di  (dataset 300342)
- dataset SQL: `mysql://ba/data_set#300342`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1230