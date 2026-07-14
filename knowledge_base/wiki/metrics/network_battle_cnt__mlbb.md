# network_battle_cnt · mlbb  `network_battle_cnt__mlbb`

> 逻辑指标 [[network_battle_cnt]] 在产品线 **mlbb** 的实例

- **公式**: `sum(network_battle_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:644