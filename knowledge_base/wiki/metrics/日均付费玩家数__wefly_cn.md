# 日均付费玩家数 · wefly_cn  `日均付费玩家数__wefly_cn`

> 逻辑指标 [[日均付费玩家数]] 在产品线 **wefly_cn** 的实例

- **公式**: `pay_cnt`
- **业务口径**: (所选日期按天付费玩家数加和)/(所选日期的总天数)
- 宽表: ⚠️ 待P2  (dataset 300195)
- dataset SQL: `mysql://ba/data_set#300195`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/const.ts:222