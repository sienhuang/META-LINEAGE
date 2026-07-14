# 来源渠道  `channel_pay_user_cnt`

**业务口径**: 统计周期内下单用户上一单的下单渠道

## 怎么算
**公式**: `sum(if(last_pay_channel_yd_config = 'other', pay_user_cnt, null)) / if(max(sum_pay_user_cnt) > 0, max(sum_pay_user_cnt), 1)`

依赖的底层指标:
- [[coda]] (?) — `⚠️待D层` [待补] · 取数 `coda`
- [[gp]] (?) — `⚠️待D层` [待补] · 取数 `gp`
- [[ios]] (?) — `⚠️待D层` [待补] · 取数 `ios`
- [[last_pay_channel_yd_config]] (?) — `⚠️待D层` [待补] · 取数 `last_pay_channel_yd_config`
- [[mp]] (?) — `⚠️待D层` [待补] · 取数 `mp`
- [[other]] (?) — `⚠️待D层` [待补] · 取数 `other`
- [[pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_user_cnt`
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`
- [[unipin]] (?) — `⚠️待D层` [待补] · 取数 `unipin`
- [[web_pag]] (?) — `⚠️待D层` [待补] · 取数 `web_pag`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300330'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/PayPlatformOverview/Component/SecondaryIndicators/const.ts:151