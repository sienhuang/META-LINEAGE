# register_reten_cnt  `register_reten_cnt`

**业务口径**: 由于举报系统迭代，仅展示2024-08-01至今的数据。

## 怎么算
**公式**: `sum(register_reten_cnt_1)`

依赖的底层指标:
- [[register_reten_cnt_1]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_1`

## 数据来源
- 宽表: [[ads_decismart_reten_ltv_df]]
- dataset: ['300270', '300257']  · 产品线 scope: ['wefly_cn', 'wegame']

## 字段生成逻辑(D 层)
- **register_reten_cnt_1** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_roger_primary_di:register_reten_cnt_1`(D 层未自动解析,待补)

## 各产品线实例
- [[register_reten_cnt__wefly_cn__300270]] (scope=wefly_cn, dataset=300270, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[register_reten_cnt__wegame__300257]] (scope=wegame, dataset=300257, 宽表=mt_ads.ads_decismart_reten_ltv_df)

## 元信息
- 分类: register · tier: 长尾