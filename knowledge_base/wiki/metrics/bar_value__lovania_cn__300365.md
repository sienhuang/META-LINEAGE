# bar_value · lovania_cn  `bar_value__lovania_cn__300365`

> 逻辑指标 [[bar_value]] 在产品线 **lovania_cn** 的实例

- **公式**: `point_active_cnt`
- **业务口径**: 有登录行为的去重玩家数
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300365)
- dataset SQL: `mysql://ba/data_set#300365`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/const.ts:77