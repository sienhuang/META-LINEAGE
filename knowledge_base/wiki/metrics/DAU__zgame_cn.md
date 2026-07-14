# DAU · zgame_cn  `DAU__zgame_cn`

> 逻辑指标 [[DAU]] 在产品线 **zgame_cn** 的实例

- **公式**: `active_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300300)
- dataset SQL: `mysql://ba/data_set#300300`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/const.ts:83