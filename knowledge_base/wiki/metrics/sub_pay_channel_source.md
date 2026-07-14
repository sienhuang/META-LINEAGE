# 子渠道  `sub_pay_channel_source`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(actual_usd_amt) * 100 / sum(product_money)`

依赖的底层指标:
- [[actual_usd_amt]] (?) — `⚠️待D层` [待补] · 取数 `actual_usd_amt`
- [[product_money]] (?) — `⚠️待D层` [待补] · 取数 `product_money`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/Component/CascaderTable/const.ts:1359