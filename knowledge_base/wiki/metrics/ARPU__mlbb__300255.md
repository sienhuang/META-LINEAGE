# ARPU · mlbb  `ARPU__mlbb__300255`

> 逻辑指标 [[ARPU]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: (所选日期按天收入金额加和)/(所选日期按天活跃玩家数加和)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300255)
- dataset SQL: `mysql://ba/data_set#300255`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyOverview/const.ts:294