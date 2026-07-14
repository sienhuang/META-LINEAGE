# 竞品重合度  `compet_overlap_rate`

**业务口径**: (竞品重合玩家数)/(MLBB大盘玩家数) * 100%

## 怎么算
**公式**: `sum(compet_act_cnt)/sum(mlbb_act_cnt)`

依赖的底层指标:
- [[compet_act_cnt]] (?) — `⚠️待D层` [待补] · 取数 `compet_act_cnt`
- [[mlbb_act_cnt]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_act_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300061'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/Competitor/CompetitorAnalysis/Component/SecondaryIndicators/const.ts:16