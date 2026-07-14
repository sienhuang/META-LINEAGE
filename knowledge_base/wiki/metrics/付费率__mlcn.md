# 付费率 · mlcn  `付费率__mlcn`

> 逻辑指标 [[付费率]] 在产品线 **mlcn** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: 付费玩家数/活跃玩家数 * 100%
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:374