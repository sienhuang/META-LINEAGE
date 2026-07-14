# 老客 · mlbb  `老客__mlbb`

> 逻辑指标 [[老客]] 在产品线 **mlbb** 的实例

- **公式**: `if(pay_user_type = 2, pay_user_cnt, null)`
- **业务口径**: 统计周期内下单用户数，按照用户类型分组
- 宽表: mt_dm.dm_finance_user_channel_tz_di  (dataset 300328)
- dataset SQL: `mysql://ba/data_set#300328`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/Component/SecondaryIndicators/const.ts:80