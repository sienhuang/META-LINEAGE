# 禁赛率  `suspension_rate`

**业务口径**: 最低信誉分达90以下的玩家 / 每日参与匹配的玩家 * 100%；
数据起始日期为2024-12-18。

## 怎么算
**公式**: `sum(forbidden_fz)/sum(forbidden_fm)`

依赖的底层指标:
- [[forbidden_fm]] (?) — `⚠️待D层` [待补] · 取数 `forbidden_fm`
- [[forbidden_fz]] (?) — `⚠️待D层` [待补] · 取数 `forbidden_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1434