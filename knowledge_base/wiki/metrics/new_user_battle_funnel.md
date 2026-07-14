# 转化漏斗  `new_user_battle_funnel`

**业务口径**: 新增玩家引导 & 场次漏斗：新增首日达成各场次分层的玩家人数；
数据起始日期为2022-05-29；
由于埋点缺失，新增玩家引导转化漏斗在2024.1.31 ~ 2024.3.13  及  2024.6.25 ~ 2024.8.18 期间数据为空。

## 怎么算
**公式**: `sum(new_user_battle_cnt)`

依赖的底层指标:
- [[new_user_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `new_user_battle_cnt`
- [[new_user_battle_cnt_pre]] (?) — `⚠️待D层` [待补] · 取数 `new_user_battle_cnt_pre`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300126'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:654