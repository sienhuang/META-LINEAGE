# 匹配转化率 · mlbb  `匹配转化率__mlbb`

> 逻辑指标 [[匹配转化率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(match_trace_cnt)/sum(match_suc_cnt)`
- **业务口径**: 分母：在match服务器上匹配成功的所有玩家人次
分子：匹配成功后客户端成功弹出提示框的玩家人次
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:280