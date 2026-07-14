# 累计实收ROI  `total_actual_amt_roi`

**业务口径**: 累计实收ROI

## 怎么算
**公式**: `sum(total_actual_amt)/sum(consume_amt)`

依赖的底层指标:
- [[consume_amt]] (?) — `⚠️待D层` [待补] · 取数 `consume_amt`
- [[total_actual_amt]] (?) — `⚠️待D层` [待补] · 取数 `total_actual_amt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300408'])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PublishCnTargetMonitor/const.ts:117