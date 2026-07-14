# ping均值  `ping均值`

**业务口径**: 玩家单局战斗的ping的均值

## 怎么算
**公式**: `SUM(indicator_map['network_timedelay_cnt']) / cast(SUM(indicator_map['network_battle_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[network_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `network_battle_cnt`
- [[network_timedelay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['network_timedelay_cnt']`

## 数据来源
- 宽表: [[ads_gamebi_roger_secondary_di]]
- dataset: ['300016']  · 产品线 scope: ['mcgg']

## 字段生成逻辑(D 层)
- **network_battle_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:network_battle_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾