# value · wefly_cn  `value__wefly_cn`

> 逻辑指标 [[value]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(pay_amt/100)/sum(pay_cnt)`
- **业务口径**: 充值总金额 / 付费玩家数
- 宽表: mt_ads_realtime.realtime_charge  (dataset 300274)
- dataset SQL: `mysql://ba/data_set#300274`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:399