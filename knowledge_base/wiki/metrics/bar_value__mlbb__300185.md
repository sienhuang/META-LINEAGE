# bar_value · mlbb  `bar_value__mlbb__300185`

> 逻辑指标 [[bar_value]] 在产品线 **mlbb** 的实例

- **公式**: `point_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300185)
- dataset SQL: `mysql://ba/data_set#300185`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/NovaCnRealTime/const.ts:188