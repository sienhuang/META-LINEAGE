# 下单用户数  `pay_user_cnt`

**业务口径**: 统计周期内下单用户数，按照用户类型分组

## 怎么算
**公式**: `sum(if(pay_user_type = 2, pay_user_cnt, null)) / if(max(sum_pay_user_cnt) = 0, 1, max(sum_pay_user_cnt))`

依赖的底层指标:
- [[pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_user_cnt`
- [[pay_user_type]] (?) — `⚠️待D层` [待补] · 取数 `pay_user_type`
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300328'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/Component/SecondaryIndicators/const.ts:80