# 卡loading率  `loading_rate`

**业务口径**: battleloading阶段卡死没有正常结束loading进入到战斗中的比例

## 怎么算
**公式**: `sum(loading_cnt)/sum(loading_total_cnt)`

依赖的底层指标:
- [[loading_cnt]] (?) — `⚠️待D层` [待补] · 取数 `loading_cnt`
- [[loading_total_cnt]] (?) — `⚠️待D层` [待补] · 取数 `loading_total_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:621