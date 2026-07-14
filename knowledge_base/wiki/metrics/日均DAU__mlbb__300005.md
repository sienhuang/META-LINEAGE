# 日均DAU · mlbb  `日均DAU__mlbb__300005`

> 逻辑指标 [[日均DAU]] 在产品线 **mlbb** 的实例

- **公式**: `active_cnt`
- **业务口径**: (所选日期按天活跃玩家数进行累计)/(所选日期的总天数)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300005)
- dataset SQL: `mysql://ba/data_set#300005`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MCGGOverview/const.ts:22