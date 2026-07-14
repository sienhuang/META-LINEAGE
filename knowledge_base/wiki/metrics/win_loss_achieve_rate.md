# 胜负达成率  `win_loss_achieve_rate`

**业务口径**: 胜负干预局中，实际获胜的玩家 / 预期胜方玩家 * 100%；
数据起始日期为2025-04-01。

## 怎么算
**公式**: `sum(win_achieve_fz)/sum(win_achieve_fm)`

依赖的底层指标:
- [[win_achieve_fm]] (?) — `⚠️待D层` [待补] · 取数 `win_achieve_fm`
- [[win_achieve_fz]] (?) — `⚠️待D层` [待补] · 取数 `win_achieve_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1096