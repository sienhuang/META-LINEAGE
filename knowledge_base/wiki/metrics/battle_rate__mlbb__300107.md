# battle_rate · mlbb  `battle_rate__mlbb__300107`

> 逻辑指标 [[battle_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(carden_battle_cnt)/sum(carden_battle_cnt_total) * 100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_performance_cube_di  (dataset 300107)
- dataset SQL: `mysql://ba/data_set#300107`
- 维度: ['model_type']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:105