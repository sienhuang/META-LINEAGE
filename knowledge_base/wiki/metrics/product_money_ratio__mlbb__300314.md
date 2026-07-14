# product_money_ratio · mlbb  `product_money_ratio__mlbb__300314`

> 逻辑指标 [[product_money_ratio]] 在产品线 **mlbb** 的实例

- **公式**: `sum(product_money) / SUM(sum(product_money)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300314)
- dataset SQL: `mysql://ba/data_set#300314`
- 维度: ['pay_channel_type']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/Component/CascaderTable/const.ts:158