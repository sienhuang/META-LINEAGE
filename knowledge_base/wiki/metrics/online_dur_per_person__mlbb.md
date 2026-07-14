# online_dur_per_person · mlbb  `online_dur_per_person__mlbb`

> 逻辑指标 [[online_dur_per_person]] 在产品线 **mlbb** 的实例

- **公式**: `sum(online_dur)/sum(active_cnt)/60`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_rank_analysis  (dataset 300117)
- dataset SQL: `mysql://ba/data_set#300117`
- 维度: ['country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:1335