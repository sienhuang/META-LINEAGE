# value · wegame  `value__wegame__300283`

> 逻辑指标 [[value]] 在产品线 **wegame** 的实例

- **公式**: `pay_cnt`
- **业务口径**: 有付费行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_charge_cnt  (dataset 300283)
- dataset SQL: `mysql://ba/data_set#300283`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:261