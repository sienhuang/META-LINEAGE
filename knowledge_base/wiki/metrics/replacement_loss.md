# 更新损耗  `replacement_loss`

**业务口径**: 计算第40步到第44步间的损耗；
step 40 对应业务场景是 获取4号公告，下一步是开始强更\热更；
step 44 对应业务场景是 Patch文件保护（如果有更新，这个步骤是重启之后走到该步骤触发打点）

## 怎么算
**公式**: `1-sum(step44_cnt)/sum(step40_cnt)`

依赖的底层指标:
- [[step40_cnt]] (?) — `⚠️待D层` [待补] · 取数 `step40_cnt`
- [[step44_cnt]] (?) — `⚠️待D层` [待补] · 取数 `step44_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:475