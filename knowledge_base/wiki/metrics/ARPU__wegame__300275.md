# ARPU · wegame  `ARPU__wegame__300275`

> 逻辑指标 [[ARPU]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_amt)/100/sum(active_cnt)`
- **业务口径**: 充值总金额 / 活跃玩家数
- 宽表: mt_ads_realtime.realtime_charge  (dataset 300275)
- dataset SQL: `mysql://ba/data_set#300275`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:369