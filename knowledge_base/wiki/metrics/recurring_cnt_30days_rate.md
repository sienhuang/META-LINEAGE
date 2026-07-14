# 回流玩家  `recurring_cnt_30days_rate`

**业务口径**: 30日回流率：T-30~T-1期间未登录、且T日有登录玩家/T-30~T-1期间未登录玩家；
30日回流玩家数：当日登录过，且流失天数>=30的去重玩家数；
14日回流率：T-14~T-1期间未登录、且T日有登录玩家/T-14~T-1期间未登录玩家；
14日回流玩家数：当日登录过，且流失天数>=14的去重玩家数；

## 怎么算
**公式**: `sum(recurring_cnt_14days)`

依赖的底层指标:
- [[nologin_cnt_14days]] (?) — `⚠️待D层` [待补] · 取数 `nologin_cnt_14days`
- [[nologin_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `nologin_cnt_30days`
- [[recurring_cnt_14days]] (?) — `⚠️待D层` [待补] · 取数 `recurring_cnt_14days`
- [[recurring_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `recurring_cnt_30days`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:740