# acc_pay_amt · mlbb  `acc_pay_amt__mlbb`

> 逻辑指标 [[acc_pay_amt]] 在产品线 **mlbb** 的实例

- **公式**: `pay_amt/100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300344)
- dataset SQL: `mysql://ba/data_set#300344`
- 维度: ['country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/CascaderTable/const.ts:488