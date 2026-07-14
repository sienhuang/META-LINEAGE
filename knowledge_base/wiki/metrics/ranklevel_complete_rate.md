# 新增玩家30日段位达成率  `ranklevel_complete_rate`

**业务口径**: 新增玩家30日[大师/宗师]段位达成率:(纯净新增玩家注册后30日内[大师/宗师]及以上段位达成玩家)/(当日新增注册玩家数)*100%
数据更新周期为T+29

## 怎么算
**公式**: `sum(indicator_map['ranklevel_grandmaster_cnt'])/cast(sum(indicator_map['pure_register_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[pure_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pure_register_cnt`
- [[ranklevel_grandmaster_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['ranklevel_grandmaster_cnt']`
- [[ranklevel_master_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['ranklevel_master_cnt']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1508