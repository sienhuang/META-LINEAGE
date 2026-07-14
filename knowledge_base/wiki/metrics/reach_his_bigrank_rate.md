# 段位回归率  `reach_his_bigrank_rate`

**业务口径**: 玩家历史最高段位达成率：达到生涯最高段位的玩家数/总活跃玩家数 * 100%；
赛季最高段位达成率：达到上赛季截止80天最高段位的玩家数/总活跃玩家数 * 100%；

## 怎么算
**公式**: `sum(reach_last_season_bigrank_cnt)/sum(last_season_rank_role_cnt) `

依赖的底层指标:
- [[his_rank_role_cnt]] (?) — `⚠️待D层` [待补] · 取数 `his_rank_role_cnt`
- [[last_season_rank_role_cnt]] (?) — `⚠️待D层` [待补] · 取数 `last_season_rank_role_cnt`
- [[reach_his_bigrank_role_cnt]] (?) — `⚠️待D层` [待补] · 取数 `reach_his_bigrank_role_cnt`
- [[reach_last_season_bigrank_cnt]] (?) — `⚠️待D层` [待补] · 取数 `reach_last_season_bigrank_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300116'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:493