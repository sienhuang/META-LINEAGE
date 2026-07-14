# LTV7  `LTV7`

**业务口径**: LTV = 新增玩家累计到第N天的付费金额/新增玩家数，单位为元

## 怎么算
**公式**: `sum(register_charge_amt_7)/100/sum(register_reten_cnt_7_total)`

依赖的底层指标:
- [[register_charge_amt_7]] (?) — `⚠️待D层` [待补] · 取数 `register_charge_amt_7`
- [[register_reten_cnt_7_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_7_total`

## 数据来源
- 宽表: ⚠️ 待P2
- dataset: ['300354']  · 产品线 scope: ['zgame_cn']

## 字段生成逻辑(D 层)
- **register_reten_cnt_7_total** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_7_total`(D 层未自动解析,待补)

## 元信息
- 分类: register · tier: 长尾