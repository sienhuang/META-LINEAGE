# 月度实收率  `actual_pay_amt`

**业务口径**: 月度指标不受日期筛选器控制;
(月度实收美金金额) / (月度商品定价总金额) * 100%

## 怎么算
**公式**: `sum(indicator_map['actual_pay_amt'])/cast(sum(indicator_map['pay_amt']) as decimal(38,0))`

依赖的底层指标:
- [[actual_pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `actual_pay_amt`
- [[pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mcgg'] · tier: 长尾
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:488