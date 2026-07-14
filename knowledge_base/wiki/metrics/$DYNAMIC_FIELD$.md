# $DYNAMIC_FIELD$  `$DYNAMIC_FIELD$`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `$DYNAMIC_FIELD$/100`

依赖的底层指标:
- [[DYNAMIC_FIELD]] (?) — `⚠️待D层` [待补] · 取数 `DYNAMIC_FIELD`

## 数据来源
- 宽表: [[ads_decismart_pay_cube_di]]
- dataset: ['300343', '300090', '300344', '300083', '300081']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **DYNAMIC_FIELD** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_roger_primary_di:DYNAMIC_FIELD`(D 层未自动解析,待补)

## 各产品线实例
- [[$DYNAMIC_FIELD$__mlbb__300343]] (scope=mlbb, dataset=300343, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[$DYNAMIC_FIELD$__mlbb__300090]] (scope=mlbb, dataset=300090, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[$DYNAMIC_FIELD$__mlbb__300344]] (scope=mlbb, dataset=300344, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[$DYNAMIC_FIELD$__mlbb__300083]] (scope=mlbb, dataset=300083, 宽表=—)
- [[$DYNAMIC_FIELD$__mlbb__300081]] (scope=mlbb, dataset=300081, 宽表=—)

## 元信息
- 分类: money · tier: 长尾