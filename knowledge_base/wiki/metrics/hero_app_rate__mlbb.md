# hero_app_rate · mlbb  `hero_app_rate__mlbb`

> 逻辑指标 [[hero_app_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(day_hero_app_cnt)/sum(day_hero_app_cnt_total)*100`
- **业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M
- 宽表: test.ads_decismart_country_social_battle_exp_di  (dataset 300141)
- dataset SQL: `mysql://ba/data_set#300141`
- 维度: ['heroid']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:214