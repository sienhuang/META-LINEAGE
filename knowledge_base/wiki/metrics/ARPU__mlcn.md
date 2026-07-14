# ARPU · mlcn  `ARPU__mlcn`

> 逻辑指标 [[ARPU]] 在产品线 **mlcn** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: (当日充值总金额)/(当日活跃玩家数)
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:290