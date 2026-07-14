# 深度AI回退率  `deep_ai_rollback_rate`

**业务口径**: (每个battletime - aihooktime > 10的AI人次) / 需要深度AI接管的人次（排除58中的主动拉起和主动回退） * 100%；
数据起始日期为2024-04-25。

## 怎么算
**公式**: `sum(deep_ai_rollback_fz)/sum(deep_ai_rollback_fm)`

依赖的底层指标:
- [[deep_ai_rollback_fm]] (?) — `⚠️待D层` [待补] · 取数 `deep_ai_rollback_fm`
- [[deep_ai_rollback_fz]] (?) — `⚠️待D层` [待补] · 取数 `deep_ai_rollback_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1274