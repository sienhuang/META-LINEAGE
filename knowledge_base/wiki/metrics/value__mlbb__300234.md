# value · mlbb  `value__mlbb__300234`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `sum(login_day_cnt)/sum(create_role_day_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_create_role_retention  (dataset 300234)
- dataset SQL: `mysql://ba/data_set#300234`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/NovaRealTime/const.ts:271