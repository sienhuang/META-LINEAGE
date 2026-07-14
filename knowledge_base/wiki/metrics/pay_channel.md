# 充值渠道  `pay_channel`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `count(distinct roleid) / SUM(count(distinct roleid)) OVER (partition by logymd)`

依赖的底层指标:
- [[logymd]] (?) — `⚠️待D层` [待补] · 取数 `logymd`
- [[pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt`
- [[pay_amt_total]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt_total`
- [[pay_channel_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_channel_amt`
- [[pay_channel_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_channel_cnt`
- [[product_money]] (?) — `⚠️待D层` [待补] · 取数 `product_money`
- [[roleid]] (?) — `⚠️待D层` [待补] · 取数 `roleid`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300092'])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mcgg', 'mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:737