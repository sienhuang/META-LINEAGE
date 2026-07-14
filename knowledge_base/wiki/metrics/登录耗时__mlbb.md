# 登录耗时 · mlbb  `登录耗时__mlbb`

> 逻辑指标 [[登录耗时]] 在产品线 **mlbb** 的实例

- **公式**: `sum(logintime_cnt)/sum(logintime_total_cnt)`
- **业务口径**: 低端机玩家的登录耗时
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:372