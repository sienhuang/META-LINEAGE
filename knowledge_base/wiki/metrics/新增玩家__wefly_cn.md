# 新增玩家 · wefly_cn  `新增玩家__wefly_cn`

> 逻辑指标 [[新增玩家]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(register_reten_cnt_1)`
- **业务口径**: 除最近一天为截止服务器时间的实时留存外，其余日期均为当天完整留存
- 宽表: mt_ads_realtime.realtime_charge_cnt  (dataset 300278)
- dataset SQL: `mysql://ba/data_set#300278`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/Component/SecondaryIndicators/const.ts:212