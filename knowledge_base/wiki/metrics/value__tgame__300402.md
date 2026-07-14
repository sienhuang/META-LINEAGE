# value · tgame  `value__tgame__300402`

> 逻辑指标 [[value]] 在产品线 **tgame** 的实例

- **公式**: `day_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300402)
- dataset SQL: `mysql://ba/data_set#300402`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:77