# 玩家数 · mlbb  `玩家数__mlbb`

> 逻辑指标 [[玩家数]] 在产品线 **mlbb** 的实例

- **公式**: `sum(recall_user_battle_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_new_recall_battle_funnel  (dataset 300128)
- dataset SQL: `mysql://ba/data_set#300128`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:847