# ARPU · zgame_cn  `ARPU__zgame_cn__300350`

> 逻辑指标 [[ARPU]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(pay_amt)/100/sum(active_cnt)`
- **业务口径**: ARPU：(当日充值总金额)/(当日活跃玩家数)；ARPPU：(当天总充值金额) / (当天充值的玩家数)
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:848