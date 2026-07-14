# bar_value · mlcn  `bar_value__mlcn__300024`

> 逻辑指标 [[bar_value]] 在产品线 **mlcn** 的实例

- **公式**: `point_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_ads_realtime.realtime_login  (dataset 300024)
- dataset SQL: `mysql://ba/data_set#300024`
- 维度: ['logymd', 'point']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MlcnRealTime/const.ts:26