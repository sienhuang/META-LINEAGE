# value · zgame_cn  `value__zgame_cn`

> 逻辑指标 [[value]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: 付费玩家数 / 活跃玩家数 * 100%
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300302)
- dataset SQL: `mysql://ba/data_set#300302`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/const.ts:360