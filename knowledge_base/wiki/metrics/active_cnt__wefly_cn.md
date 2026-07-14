# active_cnt · wefly_cn  `active_cnt__wefly_cn`

> 逻辑指标 [[active_cnt]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(pay_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_charge  (dataset 300275)
- dataset SQL: `mysql://ba/data_set#300275`
- 维度: ['<dynamic>']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/Component/CascaderTable/const_countries.ts:437