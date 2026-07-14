# exchange_rate · mlbb  `exchange_rate__mlbb__300317`

> 逻辑指标 [[exchange_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_usd_amt)/SUM(cast(pay_amt as decimal(38,0)))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300317)
- dataset SQL: `mysql://ba/data_set#300317`
- 维度: ['currency']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/Component/CascaderTable/const.ts:551