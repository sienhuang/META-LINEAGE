# 白模率  `noreslv_rate`

**业务口径**: 统计每天战斗遭遇白模的玩家人数/当天战斗的玩家人数

## 怎么算
**公式**: `sum(noreslv_cnt)/sum(noreslv_total_cnt)`

依赖的底层指标:
- [[noreslv_cnt]] (?) — `⚠️待D层` [待补] · 取数 `noreslv_cnt`
- [[noreslv_total_cnt]] (?) — `⚠️待D层` [待补] · 取数 `noreslv_total_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:572