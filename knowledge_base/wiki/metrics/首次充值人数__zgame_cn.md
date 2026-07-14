# 首次充值人数 · zgame_cn  `首次充值人数__zgame_cn`

> 逻辑指标 [[首次充值人数]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(first_pay_cnt)`
- **业务口径**: 当日首次发生付费行为的玩家数
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:951