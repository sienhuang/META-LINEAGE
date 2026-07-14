# pay_cnt · mlbb  `pay_cnt__mlbb`

> 逻辑指标 [[pay_cnt]] 在产品线 **mlbb** 的实例

- **公式**: `count(distinct roleid)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300314)
- dataset SQL: `mysql://ba/data_set#300314`
- 维度: ['bill_country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/Component/CascaderTable/const.ts:1722