# item_name  `item_name`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `item_name`

依赖的底层指标:
- [[item_name]] (?) — `⚠️待D层` [待补] · 取数 `item_name`

## 数据来源
- 宽表: [[ads_decismart_item_info_di]], [[ads_decismart_item_interactive_effects_di]], [[ads_decismart_item_gift_di]]
- dataset: ['300425', '300430', '300432']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **item_name** @ `mt_ads.ads_decismart_item_info_di`
  - 口径指针: `etl://mt_ads.ads_decismart_item_info_di:item_name`(D 层未自动解析,待补)

## 各产品线实例
- [[item_name__mlbb__300425]] (scope=mlbb, dataset=300425, 宽表=mt_ads.ads_decismart_item_info_di)
- [[item_name__mlbb__300430]] (scope=mlbb, dataset=300430, 宽表=mt_ads.ads_decismart_item_interactive_effects_di)
- [[item_name__mlbb__300432]] (scope=mlbb, dataset=300432, 宽表=mt_ads.ads_decismart_item_gift_di)

## 元信息
- 分类: other · tier: 长尾