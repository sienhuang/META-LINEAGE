# 机型 · mlbb  `机型__mlbb`

> 逻辑指标 [[机型]] 在产品线 **mlbb** 的实例

- **公式**: `sum(carden_caton_cnt)/sum(carden_battle_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_performance_cube_di  (dataset 300107)
- dataset SQL: `mysql://ba/data_set#300107`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:578