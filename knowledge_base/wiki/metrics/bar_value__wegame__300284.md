# bar_value · wegame  `bar_value__wegame__300284`

> 逻辑指标 [[bar_value]] 在产品线 **wegame** 的实例

- **公式**: `sum(point_pay_amt/100)/sum(point_active_cnt)`
- **业务口径**: 充值总金额 / 活跃玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300284)
- dataset SQL: `mysql://ba/data_set#300284`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:369