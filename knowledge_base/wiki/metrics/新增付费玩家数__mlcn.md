# 新增付费玩家数 · mlcn  `新增付费玩家数__mlcn`

> 逻辑指标 [[新增付费玩家数]] 在产品线 **mlcn** 的实例

- **公式**: `sum(create_pay_cnt)`
- **业务口径**: 当日新增的玩家中出现付费行为的玩家数
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:459