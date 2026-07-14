# 实收率  `actual_usd_amt_rate`

**业务口径**: 游戏美金实际收入 / 游戏总流水 * 100%

## 怎么算
**公式**: `sum(actual_usd_amt) / sum(product_money)`

依赖的底层指标:
- [[actual_usd_amt]] (?) — `⚠️待D层` [待补] · 取数 `actual_usd_amt`
- [[product_money]] (?) — `⚠️待D层` [待补] · 取数 `product_money`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300311'])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/const.ts:94