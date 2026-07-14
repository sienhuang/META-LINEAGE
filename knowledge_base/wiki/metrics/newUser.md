# 新增次/7/30留率  `newUser`

**业务口径**: 新增次留率：(T日新增、且T+1日登录的去重玩家数) / (T日新增的去重玩家数) * 100%
新增7留率：(T日新增、且T+6日登录的去重玩家数) / (T日新增的去重玩家数) * 100%
新增30留率：(T日新增、且T+29日登录的去重玩家数) / (T日新增的去重玩家数) * 100%

## 怎么算
**公式**: `sum(register_day30)/sum(register_day1)`

依赖的底层指标:
- [[register_day1]] (?) — `⚠️待D层` [待补] · 取数 `register_day1`
- [[register_day2]] (?) — `⚠️待D层` [待补] · 取数 `register_day2`
- [[register_day30]] (?) — `⚠️待D层` [待补] · 取数 `register_day30`
- [[register_day7]] (?) — `⚠️待D层` [待补] · 取数 `register_day7`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300012'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:296