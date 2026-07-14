# 人均在线时长  `online_avg`

**业务口径**: 玩家当天人均在线时长，单位为分钟

## 怎么算
**公式**: `sum(online_dur)/sum(active_cnt)/60`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[online_dur]] (?) — `⚠️待D层` [待补] · 取数 `online_dur`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300086'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:71