# ios_extra · mlbb  `ios_extra__mlbb__300330`

> 逻辑指标 [[ios_extra]] 在产品线 **mlbb** 的实例

- **公式**: `sum(if(last_pay_channel_yd_config = 'ios', pay_user_cnt, null)) / if(max(sum_pay_user_cnt) > 0, max(sum_pay_user_cnt), 1)`
- **业务口径**: 统计周期内下单用户上一单的下单渠道
- 宽表: mt_dm.dm_finance_user_channel_tz_di  (dataset 300330)
- dataset SQL: `mysql://ba/data_set#300330`
- 维度: ['logymd']  · 过滤: —
- 来源代码: src/views/PayPlatformOverview/Component/SecondaryIndicators/const.ts:151