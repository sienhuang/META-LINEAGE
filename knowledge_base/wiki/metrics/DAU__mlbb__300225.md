# DAU · mlbb  `DAU__mlbb__300225`

> 逻辑指标 [[DAU]] 在产品线 **mlbb** 的实例

- **公式**: `day_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300225)
- dataset SQL: `mysql://ba/data_set#300225`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/NovaRealTime/const.ts:22