# num · mlbb  `num__mlbb__300228`

> 逻辑指标 [[num]] 在产品线 **mlbb** 的实例

- **公式**: `sum(login_day_cnt)/sum(create_role_day_cnt) * 100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_create_role_retention  (dataset 300228)
- dataset SQL: `mysql://ba/data_set#300228`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/NovaRealTime/const.ts:271