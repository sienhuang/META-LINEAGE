# hero_ban_rate  `hero_ban_rate`

**业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M

## 怎么算
**公式**: `sum(day_hero_ban_cnt)/sum(day_hero_ban_cnt_total)*100`

依赖的底层指标:
- [[day_hero_ban_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_ban_cnt`
- [[day_hero_ban_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_ban_cnt_total`

## 数据来源
- 宽表: [[ads_decismart_country_social_battle_exp_di]]
- dataset: ['300141']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **day_hero_ban_cnt** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_hero_ban_cnt`(D 层未自动解析,待补)
- **day_hero_ban_cnt_total** @ `test.ads_decismart_country_social_battle_exp_di`
  - 口径指针: `etl://test.ads_decismart_country_social_battle_exp_di:day_hero_ban_cnt_total`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾