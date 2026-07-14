# 人均场次 · mlbb  `人均场次__mlbb`

> 逻辑指标 [[人均场次]] 在产品线 **mlbb** 的实例

- **公式**: `sum(battle_cnt)/sum(active_cnt)`
- **业务口径**: 玩家人均对局场次
- 宽表: test.ads_decismart_rank_analysis  (dataset 300116)
- dataset SQL: `mysql://ba/data_set#300116`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:605