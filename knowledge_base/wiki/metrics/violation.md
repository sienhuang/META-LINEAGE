# 违规行为  `violation`

**业务口径**: 由于举报系统迭代，仅展示2024-08-01至今的数据。

## 怎么算
**公式**: `sum(battle_complaint_violation_cnt)/sum(battle_report_violation_cnt)`

依赖的底层指标:
- [[battle_complaint_violation_cnt]] (?) — `⚠️待D层` [待补] · 取数 `battle_complaint_violation_cnt`
- [[battle_judge_violation_succ_cnt]] (?) — `⚠️待D层` [待补] · 取数 `battle_judge_violation_succ_cnt`
- [[battle_report_violation_cnt]] (?) — `⚠️待D层` [待补] · 取数 `battle_report_violation_cnt`
- [[day_battle_cnt_surr_fm]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_surr_fm`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300130'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:1376