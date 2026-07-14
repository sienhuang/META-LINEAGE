# value · mlbb  `value__mlbb__300128`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `sum(recall_user_battle_cnt)`
- **业务口径**: 回流玩家场次漏斗：30日回流后首日达成各场次分层的玩家人数
- 宽表: test.ads_decismart_new_recall_battle_funnel  (dataset 300128)
- dataset SQL: `mysql://ba/data_set#300128`
- 维度: ['recall_user_battle_funnel', 'config_order']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:785