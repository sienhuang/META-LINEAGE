# create_role_day_cnt_7d · tgame  `create_role_day_cnt_7d__tgame`

> 逻辑指标 [[create_role_day_cnt_7d]] 在产品线 **tgame** 的实例

- **公式**: `sum(create_role_day_cnt_7d)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_create_role_retention  (dataset 300407)
- dataset SQL: `mysql://ba/data_set#300407`
- 维度: ['country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const_countries.ts:589