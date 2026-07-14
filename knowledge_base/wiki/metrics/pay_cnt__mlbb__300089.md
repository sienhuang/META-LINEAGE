# pay_cnt · mlbb  `pay_cnt__mlbb__300089`

> 逻辑指标 [[pay_cnt]] 在产品线 **mlbb** 的实例

- **公式**: `pay_cnt`
- **业务口径**: 日均收入金额(定价) 或 日均税前流水金额，单位美元
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300089)
- dataset SQL: `mysql://ba/data_set#300089`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/const.ts:17