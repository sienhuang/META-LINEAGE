# LTV480 · zgame_cn  `LTV480__zgame_cn`

> 逻辑指标 [[LTV480]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(register_charge_amt_480)/100/sum(register_reten_cnt_480_total)`
- **业务口径**: LTV = 新增玩家累计到第N天的付费金额/新增玩家数，单位为元
- 宽表: ⚠️ 待P2  (dataset 300354)
- dataset SQL: `mysql://ba/data_set#300354`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:451