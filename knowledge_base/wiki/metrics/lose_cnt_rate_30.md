# 30日玩家流失  `lose_cnt_rate_30`

**业务口径**: 30日玩家流失率：30日流失人数/30日前DAU；
30日流失玩家数：T-30当天有登录、且T-29~T期间未登录玩家/T-30当天登录玩家;

## 怎么算
**公式**: `sum(lose_cnt_30ds)`

依赖的底层指标:
- [[active_cnt_30ds]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_30ds`
- [[lose_cnt_30ds]] (?) — `⚠️待D层` [待补] · 取数 `lose_cnt_30ds`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:685