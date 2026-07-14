# value · wefly5  `value__wefly5__300409`

> 逻辑指标 [[value]] 在产品线 **wefly5** 的实例

- **公式**: `day_amt/100`
- **业务口径**: 玩家充值金额，单位为美元
- 宽表: mt_ads_realtime.realtime_basic_charge  (dataset 300409)
- dataset SQL: `mysql://ba/data_set#300409`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:161