# 增量包体大小  `packageSize`

**业务口径**: 每日玩家的增量包体中位数 单位为G，数据可计算最早时间为 2023-07-01

## 怎么算
**公式**: `sum(indicator_map['gamepackage_size_64g_more'])/1024`

依赖的底层指标:
- [[gamepackage_size]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['gamepackage_size']`
- [[gamepackage_size_16g]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['gamepackage_size_16g']`
- [[gamepackage_size_32g]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['gamepackage_size_32g']`
- [[gamepackage_size_64g]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['gamepackage_size_64g']`
- [[gamepackage_size_64g_more]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['gamepackage_size_64g_more']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300017'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1331