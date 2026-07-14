# pay_amt_rate · mlbb  `pay_amt_rate__mlbb__300093`

> 逻辑指标 [[pay_amt_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_iap_amt)/sum(cast(pay_amt_total as decimal(38,0)))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300093)
- dataset SQL: `mysql://ba/data_set#300093`
- 维度: ['pay_iap']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/CascaderTable/const.ts:313