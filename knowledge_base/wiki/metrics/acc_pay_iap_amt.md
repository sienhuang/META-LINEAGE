# acc_pay_iap_amt  `acc_pay_iap_amt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `pay_iap_amt/100`

依赖的底层指标:
- [[pay_iap_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_iap_amt`

## 数据来源
- 宽表: [[ads_decismart_pay_cube_di]]
- dataset: ['300093']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **pay_iap_amt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:pay_iap_amt`(D 层未自动解析,待补)
  - 整条链路 SQL:

```sql
WITH
ads_decismart_pay_cube_di AS (
    SELECT
        ARRAY() AS pay_iap_amt
    FROM subquery_18
)
SELECT
    ads_decismart_pay_cube_di.pay_iap_amt
FROM ads_decismart_pay_cube_di;
```

## 元信息
- 分类: money · tier: 长尾