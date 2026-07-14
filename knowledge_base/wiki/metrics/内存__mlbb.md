# 内存 · mlbb  `内存__mlbb`

> 逻辑指标 [[内存]] 在产品线 **mlbb** 的实例

- **公式**: `sum(memory_pss_total[2])/cast(sum(memory_battle_cnt[2]) as decimal(38,0))`
- **业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300101)
- dataset SQL: `mysql://ba/data_set#300101`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:51