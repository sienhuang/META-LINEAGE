# 新增玩家数 · wegame  `新增玩家数__wegame`

> 逻辑指标 [[新增玩家数]] 在产品线 **wegame** 的实例

- **公式**: `register_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300273)
- dataset SQL: `mysql://ba/data_set#300273`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:139