# ARPU · mcgg  `ARPU__mcgg__300197`

> 逻辑指标 [[ARPU]] 在产品线 **mcgg** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: (当日充值总美金额)/(当日活跃玩家数) * 100%
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300197)
- dataset SQL: `mysql://ba/data_set#300197`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:405