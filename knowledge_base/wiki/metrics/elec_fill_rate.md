# 功耗  `elec_fill_rate`

**业务口径**: (角色各对局电流均值的和) / (角色战斗总场次) 单位为mA

## 怎么算
**公式**: `sum(indicator_map['elec_ma_hightall'])/cast(sum(indicator_map['elec_battle_cnt_hightall']) as decimal(38,0))`

依赖的底层指标:
- [[elec_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_battle_cnt']`
- [[elec_battle_cnt_high]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_battle_cnt_high']`
- [[elec_battle_cnt_hightall]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_battle_cnt_hightall']`
- [[elec_battle_cnt_low]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_battle_cnt_low']`
- [[elec_battle_cnt_mid]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_battle_cnt_mid']`
- [[elec_ma]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_ma']`
- [[elec_ma_high]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_ma_high']`
- [[elec_ma_hightall]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_ma_hightall']`
- [[elec_ma_low]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_ma_low']`
- [[elec_ma_mid]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['elec_ma_mid']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1164