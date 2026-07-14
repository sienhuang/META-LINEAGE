# 活跃度 · mlcn  `活跃度__mlcn`

> 逻辑指标 [[活跃度]] 在产品线 **mlcn** 的实例

- **公式**: `sum(active_cnt)/sum(active_cnt_30days)`
- **业务口径**: (日活跃) / (近30日去重活跃玩家数) * 100%
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:159