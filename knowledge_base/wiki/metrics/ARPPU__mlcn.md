# ARPPU · mlcn  `ARPPU__mlcn`

> 逻辑指标 [[ARPPU]] 在产品线 **mlcn** 的实例

- **公式**: `sum(pay_amt/100)/sum(pay_cnt)`
- **业务口径**: (当天总充值金额) / (当天充值的玩家数)
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:332