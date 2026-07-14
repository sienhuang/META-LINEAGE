# inside_product_money_rate · mlbb  `inside_product_money_rate__mlbb__300317`

> 逻辑指标 [[inside_product_money_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(inside_product_money) * 100 / SUM(sum(inside_product_money)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300317)
- dataset SQL: `mysql://ba/data_set#300317`
- 维度: ['country', 'pay_channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/Component/CascaderTable/const.ts:1141