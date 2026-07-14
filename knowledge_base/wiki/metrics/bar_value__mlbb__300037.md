# bar_value · mlbb  `bar_value__mlbb__300037`

> 逻辑指标 [[bar_value]] 在产品线 **mlbb** 的实例

- **公式**: `point_cnt`
- **业务口径**: 当日登录过，且流失天数>=30的去重玩家数
- 宽表: mt_ads_realtime.realtime_recurring  (dataset 300037)
- dataset SQL: `mysql://ba/data_set#300037`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessRealTime/const.ts:278