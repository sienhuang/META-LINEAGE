# match_exp_matchid_avg_score · mlbb  `match_exp_matchid_avg_score__mlbb__300137`

> 逻辑指标 [[match_exp_matchid_avg_score]] 在产品线 **mlbb** 的实例

- **公式**: `sum(match_exp_matchid_socre)/sum(match_exp_match_num)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_country_social_battle_exp_di  (dataset 300137)
- dataset SQL: `mysql://ba/data_set#300137`
- 维度: ['matchid']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:1139