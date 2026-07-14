# 14天复购率  `14_day_rebuy_rate`

**业务口径**: 统计周期内下单用户数14天内复购情况

## 怎么算
**公式**: `sum(unknown) / if(max(sum_pay_user_cnt) > 0, max(sum_pay_user_cnt), 1)`

依赖的底层指标:
- [[coda]] (?) — `⚠️待D层` [待补] · 取数 `coda`
- [[gp]] (?) — `⚠️待D层` [待补] · 取数 `gp`
- [[ios]] (?) — `⚠️待D层` [待补] · 取数 `ios`
- [[mp]] (?) — `⚠️待D层` [待补] · 取数 `mp`
- [[other]] (?) — `⚠️待D层` [待补] · 取数 `other`
- [[repurchase_rate]] (?) — `⚠️待D层` [待补] · 取数 `repurchase_rate`
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`
- [[unipin]] (?) — `⚠️待D层` [待补] · 取数 `unipin`
- [[unknown]] (?) — `⚠️待D层` [待补] · 取数 `unknown`
- [[web_pag]] (?) — `⚠️待D层` [待补] · 取数 `web_pag`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300331'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/Component/SecondaryIndicators/const.ts:280