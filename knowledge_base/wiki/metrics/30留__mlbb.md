# 30留 · mlbb  `30留__mlbb`

> 逻辑指标 [[30留]] 在产品线 **mlbb** 的实例

- **公式**: `sum(recurring_reten_day30)/sum(recurring_reten_day1)`
- **业务口径**: 计算T日30日回流玩家在T+1，T+6，T+29的活跃率
- 宽表: test.ads_decismart_reten_ltv_di  (dataset 300085)
- dataset SQL: `mysql://ba/data_set#300085`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:573