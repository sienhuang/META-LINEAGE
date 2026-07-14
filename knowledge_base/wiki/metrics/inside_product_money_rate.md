# inside_product_money_rate  `inside_product_money_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(inside_product_money) * 100 / SUM(sum(inside_product_money)) OVER ()`

依赖的底层指标:
- [[inside_product_money]] (?) — `⚠️待D层` [待补] · 取数 `inside_product_money`

## 数据来源
- 宽表: [[dm_finance_role_zone_tz_di]]
- dataset: ['300317']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **inside_product_money** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_role_zone_tz_di:inside_product_money`(D 层未自动解析,待补)

## 元信息
- 分类: money · tier: 长尾