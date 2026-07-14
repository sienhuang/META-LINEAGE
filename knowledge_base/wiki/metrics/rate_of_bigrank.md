# 玩家段位分布  `rate_of_bigrank`

**业务口径**: 每日各段位玩家数/每日总玩家数 * 100%

## 怎么算
**公式**: `sum(rank_distribute_role_array)`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[rank_distribute_role_array]] (?) — `⚠️待D层` [待补] · 取数 `rank_distribute_role_array`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300124'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:544