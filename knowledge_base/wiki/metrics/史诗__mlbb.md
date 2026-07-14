# 史诗 · mlbb  `史诗__mlbb`

> 逻辑指标 [[史诗]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_battle_dur_fz_5)/sum(day_battle_dur_cnt_fm_5)/60`
- **业务口径**: 各个段位对局的平均时长  单位为分钟
- 宽表: test.ads_decismart_country_social_battle_exp_di  (dataset 300143)
- dataset SQL: `mysql://ba/data_set#300143`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:28