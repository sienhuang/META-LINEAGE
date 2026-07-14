# cnt_rate  `cnt_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_black_type_cnt)/sum(day_black_type_cnt_total) * 100`

依赖的底层指标:
- [[day_black_type_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_black_type_cnt`
- [[day_black_type_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `day_black_type_cnt_total`
- [[match_exp_match_num]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_match_num`
- [[match_exp_match_num_total]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_match_num_total`

## 数据来源
- 宽表: [[ads_decismart_country_social_battle_exp_di]]
- dataset: ['300131', '300137']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **day_black_type_cnt** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_black_type_cnt`(D 层未自动解析,待补)
- **day_black_type_cnt_total** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_black_type_cnt_total`(D 层未自动解析,待补)
- **match_exp_match_num** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:match_exp_match_num`(D 层未自动解析,待补)
- **match_exp_match_num_total** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:match_exp_match_num_total`(D 层未自动解析,待补)

## 各产品线实例
- [[cnt_rate__mlbb__300131]] (scope=mlbb, dataset=300131, 宽表=test.ads_decismart_country_social_battle_exp_di)
- [[cnt_rate__mlbb__300137]] (scope=mlbb, dataset=300137, 宽表=test.ads_decismart_country_social_battle_exp_di)

## 元信息
- 分类: other · tier: 长尾