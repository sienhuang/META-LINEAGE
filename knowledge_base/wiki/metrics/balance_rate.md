# 平衡局占比  `balance_rate`

**业务口径**: 排位匹配战斗中，在“跌宕、翻盘、碾压、小优、均衡”范围内，标签不为“碾压”的对局场数占比；数据可计算最早时间为 2024-02-14

## 怎么算
**公式**: `sum(indicator_map['balance_cnt'])/cast(sum(indicator_map['balance_battle_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[balance_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['balance_battle_cnt']`
- [[balance_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['balance_cnt']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300017'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1559