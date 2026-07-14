# 匹配成功率 · mlbb  `匹配成功率__mlbb`

> 逻辑指标 [[匹配成功率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(successcnt_match_time_fm)/sum(battlecnt_match_time_fm)`
- **业务口径**: 今日匹配成功的战局 / 总匹配战局 * 100%；
数据起始日期为2023-12-20。
- 宽表: mt_ads.ads_decismart_exp_match_battle_di  (dataset 300342)
- dataset SQL: `mysql://ba/data_set#300342`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:915