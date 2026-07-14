# 纯净新增玩家数  `pureNewUser`

**业务口径**: 当日新注册且排除回流切号、模拟器和小号回流后的去重玩家数

## 怎么算
**公式**: `sum(pure_register_cnt)`

依赖的底层指标:
- [[pure_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pure_register_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300012'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:248