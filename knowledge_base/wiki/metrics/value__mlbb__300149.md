# value · mlbb  `value__mlbb__300149`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `day_amt`
- **业务口径**: 玩家充值金额，单位为美元
- 宽表: mt_ads_realtime.realtime_charge  (dataset 300149)
- dataset SQL: `mysql://ba/data_set#300149`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MlaRealTime/const.ts:103