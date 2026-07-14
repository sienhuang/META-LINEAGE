# register_reten_cnt_3_total  `register_reten_cnt_3_total`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(register_reten_cnt_3_total)`

依赖的底层指标:
- [[register_reten_cnt_3_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_3_total`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di_us]], [[ads_decismart_reten_ltv_df]]
- dataset: ['300369', '300423']  · 产品线 scope: ['lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5']

## 字段生成逻辑(D 层)
- **register_reten_cnt_3_total** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_3_total`(D 层未自动解析,待补)

## 各产品线实例
- [[register_reten_cnt_3_total__aoz__300423]] (scope=aoz, dataset=300423, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[register_reten_cnt_3_total__lovania_cn__300369]] (scope=lovania_cn, dataset=300369, 宽表=mt_ads.ads_gamebi_roger_primary_di_us)
- [[register_reten_cnt_3_total__sgame_cn__300369]] (scope=sgame_cn, dataset=300369, 宽表=mt_ads.ads_gamebi_roger_primary_di_us)
- [[register_reten_cnt_3_total__tgame__300423]] (scope=tgame, dataset=300423, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[register_reten_cnt_3_total__wefly5__300423]] (scope=wefly5, dataset=300423, 宽表=mt_ads.ads_decismart_reten_ltv_df)

## 元信息
- 分类: register · tier: 长尾