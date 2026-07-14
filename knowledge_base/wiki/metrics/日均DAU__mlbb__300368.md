# 日均DAU · mlbb  `日均DAU__mlbb__300368`

> 逻辑指标 [[日均DAU]] 在产品线 **mlbb** 的实例

- **公式**: `active_cnt`
- **业务口径**: (所选日期按天活跃玩家数进行累计)/(所选日期的总天数)
- 宽表: mt_ads.ads_gamebi_roger_primary_di_us  (dataset 300368)
- dataset SQL: `mysql://ba/data_set#300368`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/const.ts:23