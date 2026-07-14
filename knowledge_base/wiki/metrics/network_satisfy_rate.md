# 网络满足率  `network_satisfy_rate`

**业务口径**: 一局比赛中ping值跳跃到100ms以上的次数占总体ping次数的占比小于等于5%的场次的占比

## 怎么算
**公式**: `sum(indicator_map['network_stdping_cnt'])/cast(sum(indicator_map['network_battle_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[network_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `network_battle_cnt`
- [[network_stdping_cnt]] (?) — `⚠️待D层` [待补] · 取数 `network_stdping_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mcgg'] · tier: 长尾
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:620