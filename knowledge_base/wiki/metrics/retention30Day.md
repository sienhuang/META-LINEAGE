# 30日回流玩家次/30留率  `retention30Day`

**业务口径**: 30日回流玩家次留率：(T日回流、且T+1日登录的去重玩家数) / (T日回流的去重玩家数) * 100%
30日回流玩家30留率：(T日回流、且T+29日登录的去重玩家数) / (T日回流的去重玩家数) * 100%

## 怎么算
**公式**: `sum(recurring_day30)/ sum(recurring_day1)`

依赖的底层指标:
- [[recurring_day1]] (?) — `⚠️待D层` [待补] · 取数 `recurring_day1`
- [[recurring_day2]] (?) — `⚠️待D层` [待补] · 取数 `recurring_day2`
- [[recurring_day30]] (?) — `⚠️待D层` [待补] · 取数 `recurring_day30`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300012'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:456