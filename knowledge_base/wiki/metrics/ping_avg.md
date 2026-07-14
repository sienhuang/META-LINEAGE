# 平均ping值  `ping_avg`

**业务口径**: 玩家单局战斗的ping的均值

## 怎么算
**公式**: `SUM(indicator_map['network_timedelay_cnt']) / cast(SUM(indicator_map['network_battle_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[network_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `network_battle_cnt`
- [[network_timedelay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['network_timedelay_cnt']`
- [[ping_total]] (?) — `⚠️待D层` [待补] · 取数 `ping_total`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016', '300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mcgg', 'mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:145