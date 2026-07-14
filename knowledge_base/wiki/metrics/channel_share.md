# 渠道份额  `channel_share`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(mp_product_money)/sum(product_money)`

依赖的底层指标:
- [[mp_product_money]] (?) — `⚠️待D层` [待补] · 取数 `mp_product_money`
- [[product_money]] (?) — `⚠️待D层` [待补] · 取数 `product_money`
- [[third_product_money]] (?) — `⚠️待D层` [待补] · 取数 `third_product_money`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300311'])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/const.ts:243