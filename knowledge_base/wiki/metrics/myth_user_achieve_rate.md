# 神话率  `myth_user_achieve_rate`

**业务口径**: 当日达成神话及以上段位的玩家数 / 活跃玩家数  * 100%

## 怎么算
**公式**: `sum(myth_user_cnt_fz)/sum(myth_user_cnt_total_fm)`

依赖的底层指标:
- [[myth_user_cnt_fz]] (?) — `⚠️待D层` [待补] · 取数 `myth_user_cnt_fz`
- [[myth_user_cnt_total_fm]] (?) — `⚠️待D层` [待补] · 取数 `myth_user_cnt_total_fm`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300130'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1007