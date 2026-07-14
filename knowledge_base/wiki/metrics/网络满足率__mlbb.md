# 网络满足率 · mlbb  `网络满足率__mlbb`

> 逻辑指标 [[网络满足率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(network_stdping_cnt)/sum(network_battle_cnt)`
- **业务口径**: 一局比赛中ping值跳跃到100ms以上的次数占总体ping次数的占比小于等于5%的场次的占比
- 宽表: mt_ads_pre.ads_decismart_performance_cube_di  (dataset 300098)
- dataset SQL: `mysql://ba/data_set#300098`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/const.ts:95