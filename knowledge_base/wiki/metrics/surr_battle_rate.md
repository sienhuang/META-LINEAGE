# 投降率  `surr_battle_rate`

**业务口径**: 任意一方投降对局数 / 今日总局数 * 100%

## 怎么算
**公式**: `sum(day_battle_cnt_surr_fz)/sum(day_battle_cnt_surr_fm)`

依赖的底层指标:
- [[day_battle_cnt_surr_fm]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_surr_fm`
- [[day_battle_cnt_surr_fz]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_surr_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300140'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:164