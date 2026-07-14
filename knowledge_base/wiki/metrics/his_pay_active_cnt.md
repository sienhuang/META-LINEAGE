# 历史充值DAU  `his_pay_active_cnt`

**业务口径**: 当日活跃且历史有过充值的玩家数

## 怎么算
**公式**: `sum(his_pay_active_cnt)`

依赖的底层指标:
- [[his_pay_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `his_pay_active_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300089'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:104