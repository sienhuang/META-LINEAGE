# 人均场次  `battle_cnt_per_person`

**业务口径**: 玩家人均对局场次

## 怎么算
**公式**: `sum(battle_cnt)/sum(active_cnt)`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `battle_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300116'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:605