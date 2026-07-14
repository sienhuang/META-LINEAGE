# active_cnt · lovania_cn  `active_cnt__lovania_cn__300366`

> 逻辑指标 [[active_cnt]] 在产品线 **lovania_cn** 的实例

- **公式**: `sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.ads_mlbb_realtime_batch_data_di  (dataset 300366)
- dataset SQL: `mysql://ba/data_set#300366`
- 维度: ['province_key']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/Component/CascaderTable/const.ts:542