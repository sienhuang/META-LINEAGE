# 小重连次数均值  `smallreconnect_per10min_cnt`

**业务口径**: 角色各对局(smallreconnect_num/battletime*600)的和 / 角色战斗总场次,相当于平均10分钟小重连次数

## 怎么算
**公式**: ` SUM(indicator_map['smallreconnect_per10min_cnt']) / cast(SUM(indicator_map['smallreconnect_per10min_battle_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[smallreconnect_per10min_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['smallreconnect_per10min_battle_cnt']`
- [[smallreconnect_per10min_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['smallreconnect_per10min_cnt']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mcgg'] · tier: 长尾
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:703