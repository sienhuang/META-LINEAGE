# 英雄拥有率  `heroOwnRate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `ifnull(sum(resource_num) / sum(active_cnt),0)`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[resource_array]] (?) — `⚠️待D层` [待补] · 取数 `resource_array`
- [[resource_num]] (?) — `⚠️待D层` [待补] · 取数 `resource_num`
- [[resoure_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `resoure_active_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300056'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:793