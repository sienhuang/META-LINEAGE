# 纯净新增玩家  `pure_register_cnt`

**业务口径**: 由于举报系统迭代，仅展示2024-08-01至今的数据。

## 怎么算
**公式**: `sum(register_cnt)-sum(pure_register_cnt)`

依赖的底层指标:
- [[pure_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pure_register_cnt`
- [[register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `register_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200004', '200008', '300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb', 'mlcn'] · tier: 长尾
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:249