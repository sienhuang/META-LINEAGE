# value · mlbb  `value__mlbb__300036`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `day_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role_test  (dataset 300036)
- dataset SQL: `mysql://ba/data_set#300036`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessRealTime/const.ts:193