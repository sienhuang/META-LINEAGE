# 日均回流玩家数  `recurring_cnt_30days`

**业务口径**: (所选日期按天回流玩家数进行累计)/(所选日期的总天数)

## 怎么算
**公式**: `active_cnt-new_active_cnt-recurring_cnt_30days`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_cnt`
- [[new_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `new_active_cnt`
- [[point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `point_cnt`
- [[recurring_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `recurring_cnt_30days`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300005', '300023', '300037', '300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/const.ts:372