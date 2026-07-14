# unipin渠道复购用户数 · mlbb  `unipin渠道复购用户数__mlbb__300331`

> 逻辑指标 [[unipin渠道复购用户数]] 在产品线 **mlbb** 的实例

- **公式**: `unipin`
- **业务口径**: 统计周期内下单用户数14天内复购情况
- 宽表: mt_dm.dm_finance_user_channel_tz_di  (dataset 300331)
- dataset SQL: `mysql://ba/data_set#300331`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/Component/SecondaryIndicators/const.ts:280