# bar_value · mlbb  `bar_value__mlbb__300035`

> 逻辑指标 [[bar_value]] 在产品线 **mlbb** 的实例

- **公式**: `point_amt`
- **业务口径**: 玩家充值金额，单位为美元
- 宽表: mt_ads_realtime.realtime_charge  (dataset 300035)
- dataset SQL: `mysql://ba/data_set#300035`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessRealTime/const.ts:106