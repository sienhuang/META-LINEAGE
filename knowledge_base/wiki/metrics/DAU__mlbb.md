# DAU · mlbb  `DAU__mlbb`

> 逻辑指标 [[DAU]] 在产品线 **mlbb** 的实例

- **公式**: `day_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300144)
- dataset SQL: `mysql://ba/data_set#300144`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameRealTime/const.ts:21