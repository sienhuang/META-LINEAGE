# 新增LTV  `ltv`

**业务口径**: LTV=新增玩家累计到第N天的付费金额/新增玩家数，单位为美元

## 怎么算
**公式**: `sum(register_charge_day180)/sum(register_reten_cnt)/100`

依赖的底层指标:
- [[register_charge_day180]] (?) — `⚠️待D层` [待补] · 取数 `register_charge_day180`
- [[register_charge_day30]] (?) — `⚠️待D层` [待补] · 取数 `register_charge_day30`
- [[register_charge_day60]] (?) — `⚠️待D层` [待补] · 取数 `register_charge_day60`
- [[register_charge_day90]] (?) — `⚠️待D层` [待补] · 取数 `register_charge_day90`
- [[register_reten_cnt]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300085'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:338