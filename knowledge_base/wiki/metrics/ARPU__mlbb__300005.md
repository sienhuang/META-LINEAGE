# ARPU · mlbb  `ARPU__mlbb__300005`

> 逻辑指标 [[ARPU]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: 日均收入金额/日均活跃
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300005)
- dataset SQL: `mysql://ba/data_set#300005`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/Wefly2Overview/const.ts:214