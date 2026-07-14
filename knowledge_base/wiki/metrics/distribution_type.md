# distribution_type  `distribution_type`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `distribution_type`

依赖的底层指标:
- [[distribution_type]] (?) — `⚠️待D层` [待补] · 取数 `distribution_type`

## 数据来源
- 宽表: [[ads_decismart_item_info_di]]
- dataset: ['300425']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **distribution_type** @ `mt_ads.ads_decismart_item_info_di`
  - 口径指针: `etl://mt_ads.ads_decismart_item_info_di:distribution_type`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾