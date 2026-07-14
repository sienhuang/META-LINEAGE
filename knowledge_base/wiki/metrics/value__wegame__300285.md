# value · wegame  `value__wegame__300285`

> 逻辑指标 [[value]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: 付费玩家数 / 活跃玩家数 * 100%
- 宽表: mt_ads_realtime.realtime_login  (dataset 300285)
- dataset SQL: `mysql://ba/data_set#300285`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:319