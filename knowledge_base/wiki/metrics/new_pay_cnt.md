# 新增付费玩家数  `new_pay_cnt`

**业务口径**: 当日新增的玩家中出现付费行为的玩家数

## 怎么算
**公式**: `sum(create_pay_cnt)`

依赖的底层指标:
- [[create_pay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `create_pay_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200008'])
- 维度: —  · 过滤: —

## 元信息
- 分类: pay-cnt · 产品线: ['mlcn'] · tier: 长尾
- 来源代码: src/views/MlcnOverview/Component/SecondaryIndicators/const.ts:459