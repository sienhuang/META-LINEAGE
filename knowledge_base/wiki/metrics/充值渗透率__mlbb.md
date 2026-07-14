# 充值渗透率 · mlbb  `充值渗透率__mlbb`

> 逻辑指标 [[充值渗透率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: (当天充值的玩家数) / (当天活跃玩家数) * 100%
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300089)
- dataset SQL: `mysql://ba/data_set#300089`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:199