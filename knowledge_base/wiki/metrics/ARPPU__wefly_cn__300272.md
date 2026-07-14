# ARPPU · wefly_cn  `ARPPU__wefly_cn__300272`

> 逻辑指标 [[ARPPU]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(pay_amt/100)/sum(pay_cnt)`
- **业务口径**: 充值总金额 / 付费玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300272)
- dataset SQL: `mysql://ba/data_set#300272`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:399