# 30日回流率  `retention30DayRate`

**业务口径**: T-30~T-1期间未登录、且T日有登录玩家/T-30~T-1期间未登录玩家

## 怎么算
**公式**: `sum(recurring_cnt_30days)/sum(nologin_cnt_30days)`

依赖的底层指标:
- [[nologin_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `nologin_cnt_30days`
- [[recurring_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `recurring_cnt_30days`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300012'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:414