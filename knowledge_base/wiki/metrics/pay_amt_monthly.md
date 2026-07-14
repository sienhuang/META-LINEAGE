# 月度累计收入金额  `pay_amt_monthly`

**业务口径**: 月度指标不受日期筛选器控制;
月度累计收入金额，单位人民币

## 怎么算
**公式**: `pay_amt / 100`

依赖的底层指标:
- [[pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300417'])
- 维度: —  · 过滤: —

## 元信息
- 分类: money · 产品线: ['mlcn'] · tier: 长尾
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:543