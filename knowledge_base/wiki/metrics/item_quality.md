# item_quality  `item_quality`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `item_quality`

依赖的底层指标:
- [[item_quality]] (?) — `⚠️待D层` [待补] · 取数 `item_quality`

## 数据来源
- 宽表: [[ads_decismart_primary_cube_di]]
- dataset: ['300428']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **item_quality** @ `mt_ads.ads_decismart_primary_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_primary_cube_di:item_quality`(D 层未自动解析,待补)

## 元信息
- 分类: core-dau · tier: 长尾