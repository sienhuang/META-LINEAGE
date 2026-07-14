# LTV90  `LTV90`

**业务口径**: LTV = 新增玩家累计到第N天的付费金额/新增玩家数，单位为元

## 怎么算
**公式**: `sum(register_charge_amt_90)/100/sum(register_reten_cnt_90_total)`

依赖的底层指标:
- [[register_charge_amt_90]] (?) — `⚠️待D层` [待补] · 取数 `register_charge_amt_90`
- [[register_reten_cnt_90_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_90_total`

## 数据来源
- 宽表: ⚠️ 待P2
- dataset: ['300354']  · 产品线 scope: ['zgame_cn']

## 元信息
- 分类: register · tier: 长尾