# 卡顿满足率  `pure_reten_cnt_2_7_30`

**业务口径**: 平均每10分钟大卡次数<=2的角色战斗总场次/角色战斗总场次*100%；
卡顿满足率已于2025.04.22从[client_battleend_performance] 改为 [client_battleend_performance_mc]

## 怎么算
**公式**: `sum(indicator_map['carden_caton_cnt_hightall'])/cast(sum(indicator_map['carden_battle_cnt_hightall']) as decimal(38,0))`

依赖的底层指标:
- [[carden_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_battle_cnt']`
- [[carden_battle_cnt_high]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_battle_cnt_high']`
- [[carden_battle_cnt_hightall]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_battle_cnt_hightall']`
- [[carden_battle_cnt_low]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_battle_cnt_low']`
- [[carden_battle_cnt_mid]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_battle_cnt_mid']`
- [[carden_caton_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt']`
- [[carden_caton_cnt_high]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt_high']`
- [[carden_caton_cnt_hightall]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt_hightall']`
- [[carden_caton_cnt_low]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt_low']`
- [[carden_caton_cnt_mid]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt_mid']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mcgg'] · tier: 长尾
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:544