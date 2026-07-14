# value · wefly_cn  `value__wefly_cn__300288`

> 逻辑指标 [[value]] 在产品线 **wefly_cn** 的实例

- **公式**: `pay_cnt`
- **业务口径**: 有付费行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300288)
- dataset SQL: `mysql://ba/data_set#300288`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:253