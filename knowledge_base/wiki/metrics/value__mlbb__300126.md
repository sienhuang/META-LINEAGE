# value · mlbb  `value__mlbb__300126`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `sum(new_user_battle_cnt)`
- **业务口径**: 新增玩家引导 & 场次漏斗：新增首日达成各场次分层的玩家人数；
数据起始日期为2022-05-29；
由于埋点缺失，新增玩家引导转化漏斗在2024.1.31 ~ 2024.3.13  及  2024.6.25 ~ 2024.8.18 期间数据为空。
- 宽表: test.ads_decismart_new_recall_battle_funnel  (dataset 300126)
- dataset SQL: `mysql://ba/data_set#300126`
- 维度: ['new_user_battle_funnel', 'config_order']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:654