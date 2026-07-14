# 匹配成局率 · mlbb  `匹配成局率__mlbb`

> 逻辑指标 [[匹配成局率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(battle_begin_cnt)/sum(match_suc_cnt)`
- **业务口径**: 玩家从匹配服务器匹配成功后，成功的连上了战斗服务器的比例
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:237