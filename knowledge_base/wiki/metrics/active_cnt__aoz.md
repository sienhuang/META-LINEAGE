# active_cnt · aoz  `active_cnt__aoz`

> 逻辑指标 [[active_cnt]] 在产品线 **aoz** 的实例

- **公式**: `sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300406)
- dataset SQL: `mysql://ba/data_set#300406`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const.ts:620