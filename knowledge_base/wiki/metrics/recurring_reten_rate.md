# 回流用户  `recurring_reten_rate`

**业务口径**: 计算T日30日回流玩家在T+1，T+6，T+29的活跃率

## 怎么算
**公式**: `sum(recurring_reten_day30)/sum(recurring_reten_day1)`

依赖的底层指标:
- [[recurring_reten_day1]] (?) — `⚠️待D层` [待补] · 取数 `recurring_reten_day1`
- [[recurring_reten_day2]] (?) — `⚠️待D层` [待补] · 取数 `recurring_reten_day2`
- [[recurring_reten_day30]] (?) — `⚠️待D层` [待补] · 取数 `recurring_reten_day30`
- [[recurring_reten_day7]] (?) — `⚠️待D层` [待补] · 取数 `recurring_reten_day7`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300085'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:573