# 卡loading率 · mlbb  `卡loading率__mlbb__300099`

> 逻辑指标 [[卡loading率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(loading_cnt)/sum(loading_total_cnt)`
- **业务口径**: battleloading阶段卡死没有正常结束loading进入到战斗中的比例
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:621