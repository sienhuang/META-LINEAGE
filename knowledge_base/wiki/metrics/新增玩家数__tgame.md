# 新增玩家数 · tgame  `新增玩家数__tgame`

> 逻辑指标 [[新增玩家数]] 在产品线 **tgame** 的实例

- **公式**: `day_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_basic_create_role  (dataset 300403)
- dataset SQL: `mysql://ba/data_set#300403`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:117