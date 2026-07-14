# value · lovania_cn  `value__lovania_cn__300402`

> 逻辑指标 [[value]] 在产品线 **lovania_cn** 的实例

- **公式**: `sum(register_reten2)/sum(register_cnt_yd)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300402)
- dataset SQL: `mysql://ba/data_set#300402`
- 维度: ['logymd', 'channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/Component/CascaderTable/const_countries.ts:762