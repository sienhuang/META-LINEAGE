# DAU · wefly_cn  `DAU__wefly_cn`

> 逻辑指标 [[DAU]] 在产品线 **wefly_cn** 的实例

- **公式**: `active_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300272)
- dataset SQL: `mysql://ba/data_set#300272`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:81