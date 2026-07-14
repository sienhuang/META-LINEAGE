# compet_value · mlbb  `compet_value__mlbb__300061`

> 逻辑指标 [[compet_value]] 在产品线 **mlbb** 的实例

- **公式**: `sum(compet_act_cnt)/sum(mlbb_act_cnt)`
- **业务口径**: (竞品重合玩家数)/(MLBB大盘玩家数) * 100%
- 宽表: mt_ads.ads_gamebi_competitor_account_di  (dataset 300061)
- dataset SQL: `mysql://ba/data_set#300061`
- 维度: ['logymd', 'compet_appname']  · 过滤: ['logymd', 'definition_type']
- 来源代码: src/views/Competitor/CompetitorAnalysis/Component/SecondaryIndicators/const.ts:16