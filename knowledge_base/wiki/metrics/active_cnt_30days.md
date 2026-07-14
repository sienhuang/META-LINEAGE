# 近30日活跃玩家数  `active_cnt_30days`

**业务口径**: 含统计日当天，最近30天的去重活跃玩家数

## 怎么算
**公式**: `sum(active_cnt_30days)`

依赖的底层指标:
- [[active_cnt_30days]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_30days`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200008', '300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb', 'mlcn'] · tier: 长尾
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:71