# 新增玩家数 · mlcn  `新增玩家数__mlcn`

> 逻辑指标 [[新增玩家数]] 在产品线 **mlcn** 的实例

- **公式**: `day_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_create_role_test  (dataset 300020)
- dataset SQL: `mysql://ba/data_set#300020`
- 维度: —  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnRealTime/const.ts:192