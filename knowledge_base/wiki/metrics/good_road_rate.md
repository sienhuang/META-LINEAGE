# 分路好局率  `good_road_rate`

**业务口径**: 好局场次 / 所有对局场次 * 100%;
好局：一场对局内, 没有任何分路交换, 没有实际分路冲突, 没有英雄和分路不匹配, 没有分路客诉；
数据起始日期为2025-04-07；
当仅选择部分国家时该看板数据不做展示。

## 怎么算
**公式**: `sum(road_good_fz)/sum(road_good_fm)`

依赖的底层指标:
- [[road_good_fm]] (?) — `⚠️待D层` [待补] · 取数 `road_good_fm`
- [[road_good_fz]] (?) — `⚠️待D层` [待补] · 取数 `road_good_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1051