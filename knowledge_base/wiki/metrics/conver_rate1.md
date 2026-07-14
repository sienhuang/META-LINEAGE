# conver_rate1  `conver_rate1`

**业务口径**: MP渠道转化分析

## 怎么算
**公式**: `a2 / a1`

依赖的底层指标:
- [[a1]] (?) — `⚠️待D层` [待补] · 取数 `a1`
- [[a2]] (?) — `⚠️待D层` [待补] · 取数 `a2`

## 数据来源
- 宽表: [[ads_decismart_finance_indicator_di]]
- dataset: ['300329']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **a1** @ `mt_ads.ads_decismart_finance_indicator_di`
  - 口径指针: `etl://mt_ads.ads_decismart_finance_indicator_di:a1`(D 层未自动解析,待补)
- **a2** @ `mt_ads.ads_decismart_finance_indicator_di`
  - 口径指针: `etl://mt_ads.ads_decismart_finance_indicator_di:a2`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾