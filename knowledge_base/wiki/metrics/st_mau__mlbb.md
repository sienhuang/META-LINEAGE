# st_mau · mlbb  `st_mau__mlbb`

> 逻辑指标 [[st_mau]] 在产品线 **mlbb** 的实例

- **公式**: `st_mau`
- **业务口径**: 「下载量top100」、「MAU top100」、「收入金额top100」游戏并集，总数可能超过100
- 宽表: mt_ads.ads_gamebi_competitor_gamemarket_mf  (dataset 300068)
- dataset SQL: `mysql://ba/data_set#300068`
- 维度: ['app_name']  · 过滤: ['logymd', 'definition_type']
- 来源代码: src/views/Competitor/MarketAnalysis/Component/TableCard/const.ts:43