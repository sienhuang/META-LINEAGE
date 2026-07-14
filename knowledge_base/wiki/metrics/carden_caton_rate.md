# carden_caton_rate  `carden_caton_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(carden_caton_cnt)/sum(carden_battle_cnt) * 100`

依赖的底层指标:
- [[carden_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `carden_battle_cnt`
- [[carden_caton_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt']`

## 数据来源
- 宽表: [[ads_decismart_performance_cube_di]], [[ads_decismart_performance_cube_di]]
- dataset: ['300099', '300107']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **carden_battle_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:carden_battle_cnt`(D 层未自动解析,待补)

## 各产品线实例
- [[carden_caton_rate__mlbb__300099]] (scope=mlbb, dataset=300099, 宽表=mt_ads.ads_decismart_performance_cube_di)
- [[carden_caton_rate__mlbb__300107]] (scope=mlbb, dataset=300107, 宽表=test.ads_decismart_performance_cube_di)

## 元信息
- 分类: other · tier: 长尾