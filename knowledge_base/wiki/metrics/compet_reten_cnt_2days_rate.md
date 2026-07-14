# 竞品重合次留  `compet_reten_cnt_2days_rate`

**业务口径**: (T+1日登录的重合玩家去重) / (T日重合玩家去重) * 100%

## 怎么算
**公式**: `sum(mlbb_reten_cnt_2days)/sum(mlbb_act_cnt)`

依赖的底层指标:
- [[compet_act_cnt]] (?) — `⚠️待D层` [待补] · 取数 `compet_act_cnt`
- [[compet_reten_cnt_2days]] (?) — `⚠️待D层` [待补] · 取数 `compet_reten_cnt_2days`
- [[mlbb_act_cnt]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_act_cnt`
- [[mlbb_reten_cnt_2days]] (?) — `⚠️待D层` [待补] · 取数 `mlbb_reten_cnt_2days`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300061'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/Competitor/CompetitorAnalysis/Component/SecondaryIndicators/const.ts:144