# mlbb_value · mlbb  `mlbb_value__mlbb`

> 逻辑指标 [[mlbb_value]] 在产品线 **mlbb** 的实例

- **公式**: `sum(mlbb_reten_cnt_30days)/sum(mlbb_act_cnt)`
- **业务口径**: (T+29日登录的重合玩家去重) / (T日重合玩家去重) * 100%
- 宽表: mt_ads.ads_gamebi_competitor_account_di  (dataset 300061)
- dataset SQL: `mysql://ba/data_set#300061`
- 维度: ['logymd', 'compet_appname']  · 过滤: ['logymd', 'definition_type']
- 来源代码: src/views/Competitor/CompetitorAnalysis/Component/SecondaryIndicators/const.ts:274