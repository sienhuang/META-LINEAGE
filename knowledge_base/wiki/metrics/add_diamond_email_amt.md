# 邮件发钻  `add_diamond_email_amt`

**业务口径**: 当日邮件发出的钻石数量，包含公司内发钻、用户补偿等，与金额类型无关

## 怎么算
**公式**: `sum(add_diamond_email_amt)`

依赖的底层指标:
- [[add_diamond_email_amt]] (?) — `⚠️待D层` [待补] · 取数 `add_diamond_email_amt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300089'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:386