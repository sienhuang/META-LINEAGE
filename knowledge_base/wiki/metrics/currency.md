# 汇率  `currency`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pay_usd_amt)/SUM(cast(pay_amt as decimal(38,0)))`

依赖的底层指标:
- [[pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt`
- [[pay_usd_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_usd_amt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/Component/CascaderTable/const.ts:551