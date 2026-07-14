# value · wegame  `value__wegame__300281`

> 逻辑指标 [[value]] 在产品线 **wegame** 的实例

- **公式**: `pay_amt/100`
- **业务口径**: 玩家充值金额，单位为美元
- 宽表: mt_ads_realtime.realtime_charge  (dataset 300281)
- dataset SQL: `mysql://ba/data_set#300281`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:200