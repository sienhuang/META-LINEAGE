# 在线玩家数 · zgame_cn  `在线玩家数__zgame_cn__300302`

> 逻辑指标 [[在线玩家数]] 在产品线 **zgame_cn** 的实例

- **公式**: `online_num`
- **业务口径**: 实时在线玩家数（不支持创号渠道筛选）
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300302)
- dataset SQL: `mysql://ba/data_set#300302`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/const.ts:195