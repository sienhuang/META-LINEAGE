# 功耗  `elec_ma`

**业务口径**: (角色各对局电流均值的和) / (角色战斗总场次) 单位为mA

## 怎么算
**公式**: `sum(elec_ma[1])/sum(elec_battle_cnt[1])`

依赖的底层指标:
- [[elec_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_battle_cnt']`
- [[elec_ma]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_ma']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300101'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:95