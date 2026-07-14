# match_exp_matchid_avg_score  `match_exp_matchid_avg_score`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(match_exp_matchid_socre)/sum(match_exp_match_num)`

依赖的底层指标:
- [[match_exp_match_num]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_match_num`
- [[match_exp_matchid_socre]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_matchid_socre`

## 数据来源
- 宽表: [[ads_decismart_country_social_battle_exp_di]]
- dataset: ['300137', '300139']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **match_exp_match_num** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:match_exp_match_num`(D 层未自动解析,待补)
- **match_exp_matchid_socre** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:match_exp_matchid_socre`(D 层未自动解析,待补)

## 各产品线实例
- [[match_exp_matchid_avg_score__mlbb__300137]] (scope=mlbb, dataset=300137, 宽表=test.ads_decismart_country_social_battle_exp_di)
- [[match_exp_matchid_avg_score__mlbb__300139]] (scope=mlbb, dataset=300139, 宽表=test.ads_decismart_country_social_battle_exp_di)

## 元信息
- 分类: other · tier: 长尾