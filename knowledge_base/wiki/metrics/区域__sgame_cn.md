# 区域 · sgame_cn  `区域__sgame_cn`

> 逻辑指标 [[区域]] 在产品线 **sgame_cn** 的实例

- **公式**: `pay_amt * 0.01`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.ads_mlbb_realtime_batch_data_di  (dataset 300366)
- dataset SQL: `mysql://ba/data_set#300366`
- 维度: ['city']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/Component/CascaderTable/const_countries.ts:317