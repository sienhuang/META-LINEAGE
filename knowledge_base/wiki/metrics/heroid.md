# 分类  `heroid`

**业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M

## 怎么算
**公式**: `sum(day_hero_win_cnt)/sum(day_hero_app_cnt)*100`

依赖的底层指标:
- [[day_hero_app_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_app_cnt`
- [[day_hero_app_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_app_cnt_total`
- [[day_hero_ban_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_ban_cnt`
- [[day_hero_ban_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_ban_cnt_total`
- [[day_hero_win_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_hero_win_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300141'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:214