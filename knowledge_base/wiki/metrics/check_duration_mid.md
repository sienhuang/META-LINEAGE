# 检测时长  `check_duration_mid`

**业务口径**: 增量检测耗时

## 怎么算
**公式**: `sum(checking_step_3/1000)`

依赖的底层指标:
- [[checking_step_1]] (?) — `⚠️待D层` [待补] · 取数 `checking_step_1`
- [[checking_step_2]] (?) — `⚠️待D层` [待补] · 取数 `checking_step_2`
- [[checking_step_3]] (?) — `⚠️待D层` [待补] · 取数 `checking_step_3`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:518