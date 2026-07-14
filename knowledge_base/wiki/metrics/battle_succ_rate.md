# 匹配成局率  `battle_succ_rate`

**业务口径**: 玩家从匹配服务器匹配成功后，成功的连上了战斗服务器的比例

## 怎么算
**公式**: `sum(battle_begin_cnt)/sum(match_suc_cnt)`

依赖的底层指标:
- [[battle_begin_cnt]] (?) — `⚠️待D层` [待补] · 取数 `battle_begin_cnt`
- [[match_suc_cnt]] (?) — `⚠️待D层` [待补] · 取数 `match_suc_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:237