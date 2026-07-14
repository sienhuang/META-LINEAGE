# 开黑率  `day_black_cnt_rate`

**业务口径**: 处于开黑状态的人员及其相应战斗总场次 / 所有人员的战斗总场次 * 100%

## 怎么算
**公式**: `sum(day_battle_black_num_country_fz)/sum(day_battle_num_country_fm)`

依赖的底层指标:
- [[day_battle_black_num_country_fz]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_black_num_country_fz`
- [[day_battle_cnt_country_fm]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_country_fm`
- [[day_battle_num_country_fm]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_num_country_fm`
- [[day_black_cnt_country_fz]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_country_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300130'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/const.ts:164