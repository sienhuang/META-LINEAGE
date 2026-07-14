# 历史充值DAU · zgame_cn  `历史充值DAU__zgame_cn__300350`

> 逻辑指标 [[历史充值DAU]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(pay_active_cnt)`
- **业务口径**: 当日活跃且历史有过充值的玩家数
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:759