# 新增玩家数 · zgame_cn  `新增玩家数__zgame_cn`

> 逻辑指标 [[新增玩家数]] 在产品线 **zgame_cn** 的实例

- **公式**: `register_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300300)
- dataset SQL: `mysql://ba/data_set#300300`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/const.ts:138