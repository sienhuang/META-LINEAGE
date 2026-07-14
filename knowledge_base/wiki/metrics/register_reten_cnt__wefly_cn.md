# register_reten_cnt · wefly_cn  `register_reten_cnt__wefly_cn`

> 逻辑指标 [[register_reten_cnt]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(register_reten_cnt_1)`
- **业务口径**: 由于举报系统迭代，仅展示2024-08-01至今的数据。
- 宽表: mt_ads.ads_decismart_reten_ltv_df  (dataset 300270)
- dataset SQL: `mysql://ba/data_set#300270`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/Component/SecondaryIndicators/const.ts:332