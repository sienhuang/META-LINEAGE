# 付费率 · wefly_cn  `付费率__wefly_cn`

> 逻辑指标 [[付费率]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt) * 100`
- **业务口径**: 付费玩家数 / 活跃玩家数 * 100%
- 宽表: mt_ads_realtime.realtime_login  (dataset 300272)
- dataset SQL: `mysql://ba/data_set#300272`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/const.ts:310