# 收入金额 · zgame_cn  `收入金额__zgame_cn`

> 逻辑指标 [[收入金额]] 在产品线 **zgame_cn** 的实例

- **公式**: `pay_amt/100`
- **业务口径**: 玩家充值金额，单位为元
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300300)
- dataset SQL: `mysql://ba/data_set#300300`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/const.ts:249