# value_7 · mlbb  `value_7__mlbb__300169`

> 逻辑指标 [[value_7]] 在产品线 **mlbb** 的实例

- **公式**: `sum(login_day_cnt_7d)/sum(create_role_day_cnt_7d)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime_pre.realtime_create_role_retention  (dataset 300169)
- dataset SQL: `mysql://ba/data_set#300169`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MCGGRealTime/const.ts:356