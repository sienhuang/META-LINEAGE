# 登录耗时  `logintime_cnt`

**业务口径**: 低端机玩家的登录耗时

## 怎么算
**公式**: `sum(logintime_cnt)/sum(logintime_total_cnt)`

依赖的底层指标:
- [[logintime_cnt]] (?) — `⚠️待D层` [待补] · 取数 `logintime_cnt`
- [[logintime_total_cnt]] (?) — `⚠️待D层` [待补] · 取数 `logintime_total_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:372