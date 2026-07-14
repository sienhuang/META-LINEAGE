# register_reten_cnt_30_total  `register_reten_cnt_30_total`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(register_reten_cnt_30_total)`

依赖的底层指标:
- [[register_reten_cnt_30_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_30_total`

## 数据来源
- 宽表: [[ads_decismart_reten_ltv_df]]
- dataset: ['300172']  · 产品线 scope: ['mcgg']

## 字段生成逻辑(D 层)
- **register_reten_cnt_30_total** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_30_total`(D 层未自动解析,待补)

## 元信息
- 分类: register · tier: 长尾