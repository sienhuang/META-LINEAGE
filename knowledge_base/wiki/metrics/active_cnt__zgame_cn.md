# active_cnt · zgame_cn  `active_cnt__zgame_cn`

> 逻辑指标 [[active_cnt]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300300)
- dataset SQL: `mysql://ba/data_set#300300`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/Component/CascaderTable/const.ts:316