# active_cnt_ratio · sgame_cn  `active_cnt_ratio__sgame_cn__300400`

> 逻辑指标 [[active_cnt_ratio]] 在产品线 **sgame_cn** 的实例

- **公式**: `sum(active_cnt) / SUM(sum(active_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_login  (dataset 300400)
- dataset SQL: `mysql://ba/data_set#300400`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/Component/CascaderTable/const.ts:97