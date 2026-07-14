# 赛季人均在线时长  `online_duration_avg`

**业务口径**: 赛季指标不受日期筛选器控制，且以赛季前80天作为计算窗口期
(总赛季累计在线时长) / (总赛季活跃玩家) 单位为分钟

## 怎么算
**公式**: `sum(indicator_map['season_online_dur'])/cast(sum(indicator_map['season_active_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[season_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['season_active_cnt']`
- [[season_online_dur]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['season_online_dur']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1457