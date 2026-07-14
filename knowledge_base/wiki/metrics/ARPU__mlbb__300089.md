# ARPU · mlbb  `ARPU__mlbb__300089`

> 逻辑指标 [[ARPU]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: (当日充值总美金额)/(当日活跃玩家数)
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300089)
- dataset SQL: `mysql://ba/data_set#300089`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:22