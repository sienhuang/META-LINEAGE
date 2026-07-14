# user_rate · mlbb  `user_rate__mlbb__300122`

> 逻辑指标 [[user_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(ol_dur_sex_role_cnt_arr)/sum(ol_dur_sex_role_cnt_arr_total)*100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_rank_analysis  (dataset 300122)
- dataset SQL: `mysql://ba/data_set#300122`
- 维度: ['sex']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:784