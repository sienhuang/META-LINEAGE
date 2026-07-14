# DAU · mlcn  `DAU__mlcn`

> 逻辑指标 [[DAU]] 在产品线 **mlcn** 的实例

- **公式**: `day_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300018)
- dataset SQL: `mysql://ba/data_set#300018`
- 维度: —  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnRealTime/const.ts:26