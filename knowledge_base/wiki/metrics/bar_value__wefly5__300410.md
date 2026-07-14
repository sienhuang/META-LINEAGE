# bar_value · wefly5  `bar_value__wefly5__300410`

> 逻辑指标 [[bar_value]] 在产品线 **wefly5** 的实例

- **公式**: `sum(point_pay_amt)/100/sum(point_active_cnt)`
- **业务口径**: 充值总金额 / 活跃玩家数
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300410)
- dataset SQL: `mysql://ba/data_set#300410`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:205