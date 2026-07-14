# DAU · tgame  `DAU__tgame__300401`

> 逻辑指标 [[DAU]] 在产品线 **tgame** 的实例

- **公式**: `day_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300401)
- dataset SQL: `mysql://ba/data_set#300401`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:77