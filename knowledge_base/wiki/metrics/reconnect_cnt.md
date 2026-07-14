# 小重连次数  `reconnect_cnt`

**业务口径**: 小重连次数：玩家战斗内产生网络重连的次数，以平均的方式聚合;
场均小重连率：至少有一次发生重连的战斗数/总战斗数

## 怎么算
**公式**: `sum(reconnect_battle_cnt)/sum(network_battle_cnt)`

依赖的底层指标:
- [[network_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `network_battle_cnt`
- [[reconnect_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `reconnect_battle_cnt`
- [[reconnect_cnt]] (?) — `⚠️待D层` [待补] · 取数 `reconnect_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:187