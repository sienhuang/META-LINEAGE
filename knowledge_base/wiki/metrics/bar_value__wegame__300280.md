# bar_value · wegame  `bar_value__wegame__300280`

> 逻辑指标 [[bar_value]] 在产品线 **wegame** 的实例

- **公式**: `point_active_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300280)
- dataset SQL: `mysql://ba/data_set#300280`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/const.ts:78