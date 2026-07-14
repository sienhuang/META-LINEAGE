# 30天长周期网络满足率  `30day_network_stdping_rate`

**业务口径**: 玩家过往30天的网络体验稳定率

## 怎么算
**公式**: `sum(score_net)/sum(network_stdping_cnt_30d)`

依赖的底层指标:
- [[network_stdping_cnt_30d]] (?) — `⚠️待D层` [待补] · 取数 `network_stdping_cnt_30d`
- [[score_net]] (?) — `⚠️待D层` [待补] · 取数 `score_net`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:323