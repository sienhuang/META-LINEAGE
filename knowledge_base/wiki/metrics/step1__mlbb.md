# step1 · mlbb  `step1__mlbb`

> 逻辑指标 [[step1]] 在产品线 **mlbb** 的实例

- **公式**: `sum(checking_step_1/1000)`
- **业务口径**: 增量检测耗时
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:518