# bar_value · wegame  `bar_value__wegame__300286`

> 逻辑指标 [[bar_value]] 在产品线 **wegame** 的实例

- **公式**: `sum(point_pay_amt/100)/sum(point_pay_cnt)`
- **业务口径**: 充值总金额 / 付费玩家数
- 宽表: mt_ads_realtime.realtime_charge_cnt  (dataset 300286)
- dataset SQL: `mysql://ba/data_set#300286`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:416