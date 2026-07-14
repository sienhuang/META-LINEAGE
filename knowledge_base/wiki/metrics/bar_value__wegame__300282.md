# bar_value · wegame  `bar_value__wegame__300282`

> 逻辑指标 [[bar_value]] 在产品线 **wegame** 的实例

- **公式**: `point_register_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300282)
- dataset SQL: `mysql://ba/data_set#300282`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:139