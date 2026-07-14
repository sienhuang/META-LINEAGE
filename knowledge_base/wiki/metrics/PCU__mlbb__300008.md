# PCU · mlbb  `PCU__mlbb__300008`

> 逻辑指标 [[PCU]] 在产品线 **mlbb** 的实例

- **公式**: `pcu`
- **业务口径**: PCU: 最大同时在线玩家数
ACU: 平均同时在线玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_cube_di  (dataset 300008)
- dataset SQL: `mysql://ba/data_set#300008`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:192