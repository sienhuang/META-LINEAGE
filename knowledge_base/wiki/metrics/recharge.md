# 新增玩家充值渗透率  `recharge`

**业务口径**: (当日活跃且新增第30天且30天内充值过的玩家) / (当日活跃且新增第30天的玩家) * 100%

## 怎么算
**公式**: `sum(active_register_pay_30d_cnt)/sum(active_register_30d_cnt)`

依赖的底层指标:
- [[active_register_30d_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_register_30d_cnt`
- [[active_register_pay_30d_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_register_pay_30d_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300012'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:609