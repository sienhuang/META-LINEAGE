# acc_pay_channel_amt · mlbb  `acc_pay_channel_amt__mlbb`

> 逻辑指标 [[acc_pay_channel_amt]] 在产品线 **mlbb** 的实例

- **公式**: `pay_channel_amt/100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300092)
- dataset SQL: `mysql://ba/data_set#300092`
- 维度: ['pay_channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:737