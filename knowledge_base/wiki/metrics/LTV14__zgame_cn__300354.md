# LTV14 · zgame_cn  `LTV14__zgame_cn__300354`

> 逻辑指标 [[LTV14]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(register_charge_amt_14)/100/sum(register_reten_cnt_14_total)`
- **业务口径**: LTV = 新增玩家累计到第N天的付费金额/新增玩家数，单位为元
- 宽表: ⚠️ 待P2  (dataset 300354)
- dataset SQL: `mysql://ba/data_set#300354`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:451