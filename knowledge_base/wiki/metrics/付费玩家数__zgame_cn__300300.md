# 付费玩家数 · zgame_cn  `付费玩家数__zgame_cn__300300`

> 逻辑指标 [[付费玩家数]] 在产品线 **zgame_cn** 的实例

- **公式**: `pay_cnt`
- **业务口径**: 有付费行为的去重玩家数
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300300)
- dataset SQL: `mysql://ba/data_set#300300`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/const.ts:306