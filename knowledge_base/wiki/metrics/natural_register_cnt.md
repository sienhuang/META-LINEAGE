# 渠道类型  `natural_register_cnt`

**业务口径**: 自然新增玩家数：当天注册的自然新增玩家数量；
广告新增玩家数：当天注册的非自然新增(视为广告新增)玩家数量;

## 怎么算
**公式**: `sum(non_natural_register_cnt)`

依赖的底层指标:
- [[natural_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `natural_register_cnt`
- [[non_natural_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `non_natural_register_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:290