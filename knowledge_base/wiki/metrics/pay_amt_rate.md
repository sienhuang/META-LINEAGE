# pay_amt_rate  `pay_amt_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pay_iap_amt)/sum(cast(pay_amt_total as decimal(38,0)))`

依赖的底层指标:
- [[pay_amt_total]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt_total`
- [[pay_iap_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_iap_amt`
- [[sub_diamond_operate_amt]] (?) — `⚠️待D层` [待补] · 取数 `sub_diamond_operate_amt`
- [[pay_channel_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_channel_amt`

## 数据来源
- 宽表: [[ads_decismart_pay_cube_di]]
- dataset: ['300093', '300091', '300092']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **pay_amt_total** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:pay_amt_total`(D 层未自动解析,待补)
- **pay_iap_amt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:pay_iap_amt`(D 层未自动解析,待补)
- **sub_diamond_operate_amt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:sub_diamond_operate_amt`(D 层未自动解析,待补)
- **pay_channel_amt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:pay_channel_amt`(D 层未自动解析,待补)

## 各产品线实例
- [[pay_amt_rate__mlbb__300093]] (scope=mlbb, dataset=300093, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[pay_amt_rate__mlbb__300091]] (scope=mlbb, dataset=300091, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[pay_amt_rate__mlbb__300092]] (scope=mlbb, dataset=300092, 宽表=mt_ads.ads_decismart_pay_cube_di)

## 元信息
- 分类: money · tier: 长尾