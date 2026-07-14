# 钻石产出&消耗  `add_diamond_amt`

**业务口径**: 钻石产出：当日系统产出的钻石数量，包含用户充值、GM发钻等，与金额类型无关；
钻石消耗：当日用户消耗的钻石数量，包含皮肤/英雄购买、星光、抽奖等，与金额类型无关；

## 怎么算
**公式**: `sum(add_diamond_amt-sub_diamond_amt)`

依赖的底层指标:
- [[add_diamond_amt]] (?) — `⚠️待D层` [待补] · 取数 `add_diamond_amt`
- [[sub_diamond_amt]] (?) — `⚠️待D层` [待补] · 取数 `sub_diamond_amt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300089'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:331