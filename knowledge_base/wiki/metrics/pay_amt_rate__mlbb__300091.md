# pay_amt_rate · mlbb  `pay_amt_rate__mlbb__300091`

> 逻辑指标 [[pay_amt_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(sub_diamond_operate_amt)/sum(cast(pay_amt_total as decimal(38,0)))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300091)
- dataset SQL: `mysql://ba/data_set#300091`
- 维度: ['sub_diamond_operate']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:534