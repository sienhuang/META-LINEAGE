# value · wefly_cn  `value__wefly_cn__300273`

> 逻辑指标 [[value]] 在产品线 **wefly_cn** 的实例

- **公式**: `active_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300273)
- dataset SQL: `mysql://ba/data_set#300273`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:81