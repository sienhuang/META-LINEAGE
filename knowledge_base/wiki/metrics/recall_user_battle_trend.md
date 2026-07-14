# 转化趋势  `recall_user_battle_trend`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(recall_user_battle_cnt)`

依赖的底层指标:
- [[recall_user_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `recall_user_battle_cnt`
- [[recall_user_battle_cnt_pre]] (?) — `⚠️待D层` [待补] · 取数 `recall_user_battle_cnt_pre`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300128'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:847