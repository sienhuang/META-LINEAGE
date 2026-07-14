# 日均纯净新增玩家数 · mlcn  `日均纯净新增玩家数__mlcn`

> 逻辑指标 [[日均纯净新增玩家数]] 在产品线 **mlcn** 的实例

- **公式**: `pure_register_cnt`
- **业务口径**: 注册日期为当天的纯净新增的玩家数量
- 宽表: ⚠️ 待P2  (dataset 200008)
- dataset SQL: `mysql://ba/data_set#200008`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnOverview/const.ts:158