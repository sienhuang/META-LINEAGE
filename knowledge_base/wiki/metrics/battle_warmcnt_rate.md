# 温暖关投放率  `battle_warmcnt_rate`

**业务口径**: 今日是温暖关的对局数 / 总对局数 * 100%；
数据起始日期为2023-09-19。

## 怎么算
**公式**: `sum(battle_warmcnt_fz)/sum(total_battle_cnt_warm_fm)`

依赖的底层指标:
- [[battle_warmcnt_fz]] (?) — `⚠️待D层` [待补] · 取数 `battle_warmcnt_fz`
- [[total_battle_cnt_warm_fm]] (?) — `⚠️待D层` [待补] · 取数 `total_battle_cnt_warm_fm`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1230