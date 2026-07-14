# day_battle_cnt_sex  `day_battle_cnt_sex`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_battle_cnt_sex)`

依赖的底层指标:
- [[day_battle_cnt_sex]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_sex`

## 数据来源
- 宽表: [[ads_decismart_country_social_battle_exp_di]]
- dataset: ['300135']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **day_battle_cnt_sex** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_battle_cnt_sex`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾