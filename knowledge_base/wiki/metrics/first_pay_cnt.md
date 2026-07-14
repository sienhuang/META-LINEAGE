# 首次充值玩家数  `first_pay_cnt`

**业务口径**: 当日首次出现充值行为的玩家数

## 怎么算
**公式**: `sum(first_pay_cnt)`

依赖的底层指标:
- [[first_pay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `first_pay_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300089'])
- 维度: —  · 过滤: —

## 元信息
- 分类: pay-cnt · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:434