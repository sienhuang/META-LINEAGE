# 平衡局占比  `balance_battle_rate`

**业务口径**: 排位匹配战斗中，在“跌宕、翻盘、碾压、小优、均衡”范围内，标签不为“碾压”的对局场数占比；
因AIAD业务迁移，平衡局占比指标数据有效日期从2024-02-13开始。

## 怎么算
**公式**: `sum(not_dominating_cnt_fz)/sum(leading_game_cnt_fm)`

依赖的底层指标:
- [[leading_game_cnt_fm]] (?) — `⚠️待D层` [待补] · 取数 `leading_game_cnt_fm`
- [[not_dominating_cnt_fz]] (?) — `⚠️待D层` [待补] · 取数 `not_dominating_cnt_fz`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1142