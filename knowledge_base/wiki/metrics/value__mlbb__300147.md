# value · mlbb  `value__mlbb__300147`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `day_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300147)
- dataset SQL: `mysql://ba/data_set#300147`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MlaRealTime/const.ts:22