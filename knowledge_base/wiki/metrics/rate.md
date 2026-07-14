# rate  `rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_black_cnt_age)/sum(day_black_cnt_age_total)*100`

依赖的底层指标:
- [[day_black_cnt_age]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_age`
- [[day_black_cnt_age_total]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_age_total`
- [[day_black_cnt_sex]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_sex`
- [[day_black_cnt_sex_total]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_sex_total`

## 数据来源
- 宽表: [[ads_decismart_country_social_battle_exp_di]]
- dataset: ['300133', '300135']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **day_black_cnt_age** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_black_cnt_age`(D 层未自动解析,待补)
- **day_black_cnt_age_total** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_black_cnt_age_total`(D 层未自动解析,待补)
- **day_black_cnt_sex** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_black_cnt_sex`(D 层未自动解析,待补)
- **day_black_cnt_sex_total** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_black_cnt_sex_total`(D 层未自动解析,待补)

## 各产品线实例
- [[rate__mlbb__300133]] (scope=mlbb, dataset=300133, 宽表=test.ads_decismart_country_social_battle_exp_di)
- [[rate__mlbb__300135]] (scope=mlbb, dataset=300135, 宽表=test.ads_decismart_country_social_battle_exp_di)

## 元信息
- 分类: other · tier: 长尾