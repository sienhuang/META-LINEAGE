# MLBB月均MAU(ST) · mlbb  `MLBB月均MAU(ST)__mlbb`

> 逻辑指标 [[MLBB月均MAU(ST)]] 在产品线 **mlbb** 的实例

- **公式**: `st_mau`
- **业务口径**: ST上获取到的MLBB的MAU
- 宽表: test.ads_gamebi_competitor_gamemarket_mi  (dataset 300064)
- dataset SQL: `mysql://ba/data_set#300064`
- 维度: ['logymd', 'app_name']  · 过滤: ['logymd', 'app_name', 'definition_type']
- 来源代码: src/views/Competitor/MarketAnalysis/const.ts:241