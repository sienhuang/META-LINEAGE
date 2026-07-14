# MLBB月均收入(ST) · mlbb  `MLBB月均收入(ST)__mlbb`

> 逻辑指标 [[MLBB月均收入(ST)]] 在产品线 **mlbb** 的实例

- **公式**: `st_income`
- **业务口径**: ST上获取到的MLBB的流水
- 宽表: test.ads_gamebi_competitor_gamemarket_mi  (dataset 300064)
- dataset SQL: `mysql://ba/data_set#300064`
- 维度: ['logymd', 'app_name']  · 过滤: ['logymd', 'app_name', 'definition_type']
- 来源代码: src/views/Competitor/MarketAnalysis/const.ts:400