# 活跃度  `active_cnt_rate`

**业务口径**: (日活跃) / (近30日去重活跃玩家数) * 100%

## 怎么算
**公式**: `sum(active_cnt)/sum(active_cnt_30days)`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[active_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_30days`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200008'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlcn'] · tier: 长尾
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:159