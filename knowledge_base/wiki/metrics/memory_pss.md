# 内存  `memory_pss`

**业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M

## 怎么算
**公式**: `sum(memory_pss_total[2])/cast(sum(memory_battle_cnt[2]) as decimal(38,0))`

依赖的底层指标:
- [[memory_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt']`
- [[memory_pss_total]] (?) — `⚠️待D层` [待补] · 取数 `memory_pss_total`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300101'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:51