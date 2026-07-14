# 日均DAU · mlcn  `日均DAU__mlcn`

> 逻辑指标 [[日均DAU]] 在产品线 **mlcn** 的实例

- **公式**: `active_cnt`
- **业务口径**: (所选日期按天活跃玩家数进行累计)/(所选日期的总天数)
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/const.ts:16