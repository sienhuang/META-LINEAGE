# ARPPU · wegame  `ARPPU__wegame__300279`

> 逻辑指标 [[ARPPU]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_amt/100)/sum(pay_cnt)`
- **业务口径**: 充值总金额 / 付费玩家数
- 宽表: mt_ads_realtime.realtime_charge_cnt  (dataset 300279)
- dataset SQL: `mysql://ba/data_set#300279`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:416