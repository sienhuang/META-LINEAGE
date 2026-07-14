# 老用户  `old_reten_rate`

**业务口径**: 计算T日活跃老玩家 在T+1，T+6，T+29的活跃率

## 怎么算
**公式**: `sum(old_reten_day30)/sum(old_reten_day1)`

依赖的底层指标:
- [[old_reten_day1]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day1`
- [[old_reten_day2]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day2`
- [[old_reten_day30]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day30`
- [[old_reten_day7]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day7`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300085'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:461