# num_30  `num_30`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pure_reten_day30)/sum(pure_reten_day30_total) * 100`

依赖的底层指标:
- [[pure_reten_day30]] (?) — `⚠️待D层` [待补] · 取数 `pure_reten_day30`
- [[pure_reten_day30_total]] (?) — `⚠️待D层` [待补] · 取数 `pure_reten_day30_total`
- [[register_reten_cnt_30]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_30`
- [[register_reten_cnt_30_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_30_total`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di]], [[ads_decismart_reten_ltv_df]]
- dataset: ['300196', '300172']  · 产品线 scope: ['mlbb', 'mcgg']

## 字段生成逻辑(D 层)
- **pure_reten_day30** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_roger_primary_di:pure_reten_day30`(D 层未自动解析,待补)
- **pure_reten_day30_total** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_roger_primary_di:pure_reten_day30_total`(D 层未自动解析,待补)
- **register_reten_cnt_30** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_30`(D 层未自动解析,待补)
- **register_reten_cnt_30_total** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_30_total`(D 层未自动解析,待补)

## 各产品线实例
- [[num_30__mcgg__300172]] (scope=mcgg, dataset=300172, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[num_30__mlbb__300196]] (scope=mlbb, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[num_30__mlbb__300172]] (scope=mlbb, dataset=300172, 宽表=mt_ads.ads_decismart_reten_ltv_df)

## 元信息
- 分类: retention · tier: 长尾