# 日均收入金额 · lovania_cn  `日均收入金额__lovania_cn`

> 逻辑指标 [[日均收入金额]] 在产品线 **lovania_cn** 的实例

- **公式**: `pay_amt`
- **业务口径**: (所选日期按天收入金额加和)/(所选日期的总天数)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300005)
- dataset SQL: `mysql://ba/data_set#300005`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnOverview/const.ts:145