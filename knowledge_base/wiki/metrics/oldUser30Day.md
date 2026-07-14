# 老用户次/7/30留率  `oldUser30Day`

**业务口径**: 老用户次留率：(T日新增天数>30日的活跃玩家数、且T+1日登录的去重玩家数) / (T日新增天数>30日的活跃玩家数) * 100%
老用户7留率：(T日新增天数>30日的活跃玩家数、且T+6日登录的去重玩家数) / (T日新增天数>30日的活跃玩家数) * 100%
老用户30留率：(T日新增天数>30日的活跃玩家数、且T+29日登录的去重玩家数) / (T日新增天数>30日的活跃玩家数) * 100%

## 怎么算
**公式**: `sum(old_reten_day30)/sum(old_reten_day1)`

依赖的底层指标:
- [[old_reten_day1]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day1`
- [[old_reten_day2]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day2`
- [[old_reten_day30]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day30`
- [[old_reten_day7]] (?) — `⚠️待D层` [待补] · 取数 `old_reten_day7`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300012'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:352