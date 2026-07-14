# 日均新增玩家数 · mlbb  `日均新增玩家数__mlbb`

> 逻辑指标 [[日均新增玩家数]] 在产品线 **mlbb** 的实例

- **公式**: `register_cnt`
- **业务口径**: 所选日期的日均新增玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300161)
- dataset SQL: `mysql://ba/data_set#300161`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameOverview/const.ts:165