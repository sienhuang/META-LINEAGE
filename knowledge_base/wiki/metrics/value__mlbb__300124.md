# value · mlbb  `value__mlbb__300124`

> 逻辑指标 [[value]] 在产品线 **mlbb** 的实例

- **公式**: `sum(rank_distribute_role_array)/sum(active_cnt)`
- **业务口径**: 每日各段位玩家数/每日总玩家数 * 100%
- 宽表: test.ads_decismart_rank_analysis  (dataset 300124)
- dataset SQL: `mysql://ba/data_set#300124`
- 维度: ['logymd', 'day_last_bigranklvl']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:544