# 新增玩家数 · wefly_cn  `新增玩家数__wefly_cn__300272`

> 逻辑指标 [[新增玩家数]] 在产品线 **wefly_cn** 的实例

- **公式**: `register_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300272)
- dataset SQL: `mysql://ba/data_set#300272`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:139