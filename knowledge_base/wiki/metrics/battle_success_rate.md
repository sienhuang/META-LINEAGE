# 开局成功率  `battle_success_rate`

**业务口径**: 玩家匹配成功且进入战斗的对局数 / 所有匹配成功的对局数 * 100%；
数据起始日期为2023-08-08。

## 怎么算
**公式**: `sum(battle_success_fz)/sum(match_success_fm)`

依赖的底层指标:
- [[battle_success_fz]] (?) — `⚠️待D层` [待补] · 取数 `battle_success_fz`
- [[match_success_fm]] (?) — `⚠️待D层` [待补] · 取数 `match_success_fm`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300130'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1186