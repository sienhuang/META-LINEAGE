# 平均ping值 · mlbb  `平均ping值__mlbb`

> 逻辑指标 [[平均ping值]] 在产品线 **mlbb** 的实例

- **公式**: `sum(ping_total)/sum(network_battle_cnt)`
- **业务口径**: 玩家单局战斗的ping的均值
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:145