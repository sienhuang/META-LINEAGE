# 内存  `memory_fill_rate`

**业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M

## 怎么算
**公式**: `sum(indicator_map['memory_pss_6g_greater_64bit'])/cast(sum(indicator_map['memory_battle_cnt_6g_greater_64bit']) as decimal(38,0))`

依赖的底层指标:
- [[memory_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt']`
- [[memory_battle_cnt_2g_32bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt_2g_32bit']`
- [[memory_battle_cnt_2g_64bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt_2g_64bit']`
- [[memory_battle_cnt_6g_32bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt_6g_32bit']`
- [[memory_battle_cnt_6g_64bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt_6g_64bit']`
- [[memory_battle_cnt_6g_greater_32bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt_6g_greater_32bit']`
- [[memory_battle_cnt_6g_greater_64bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_battle_cnt_6g_greater_64bit']`
- [[memory_pss]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss']`
- [[memory_pss_2g_32bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss_2g_32bit']`
- [[memory_pss_2g_64bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss_2g_64bit']`
- [[memory_pss_6g_32bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss_6g_32bit']`
- [[memory_pss_6g_64bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss_6g_64bit']`
- [[memory_pss_6g_greater_32bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss_6g_greater_32bit']`
- [[memory_pss_6g_greater_64bit]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['memory_pss_6g_greater_64bit']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300205'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1080