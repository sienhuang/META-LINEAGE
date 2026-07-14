# 活跃用户  `active_reten_rate`

**业务口径**: 计算T日活跃玩家在T+1，T+6，T+29的活跃率

## 怎么算
**公式**: `sum(active_reten_day30)/sum(active_reten_day1)`

依赖的底层指标:
- [[active_reten_day1]] (?) — `⚠️待D层` [待补] · 取数 `active_reten_day1`
- [[active_reten_day2]] (?) — `⚠️待D层` [待补] · 取数 `active_reten_day2`
- [[active_reten_day30]] (?) — `⚠️待D层` [待补] · 取数 `active_reten_day30`
- [[active_reten_day7]] (?) — `⚠️待D层` [待补] · 取数 `active_reten_day7`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300085'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:517