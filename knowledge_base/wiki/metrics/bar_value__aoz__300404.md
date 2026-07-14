# bar_value · aoz  `bar_value__aoz__300404`

> 逻辑指标 [[bar_value]] 在产品线 **aoz** 的实例

- **公式**: `point_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads_realtime.realtime_basic_create_role  (dataset 300404)
- dataset SQL: `mysql://ba/data_set#300404`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:117