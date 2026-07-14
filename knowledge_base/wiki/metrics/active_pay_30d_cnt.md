# 近30日充值渗透率  `active_pay_30d_cnt`

**业务口径**: (当日活跃且最近30天内充值过的玩家)/(当日DAU) * 100%

## 怎么算
**公式**: `sum(active_pay_30d_cnt)/sum(active_cnt)`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[active_pay_30d_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_pay_30d_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300089'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:283