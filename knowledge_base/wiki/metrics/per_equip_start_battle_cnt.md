# per_equip_start_battle_cnt  `per_equip_start_battle_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `avg(equip_start_battle_cnt)/avg(equip_user_cnt)`

依赖的底层指标:
- [[equip_start_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `equip_start_battle_cnt`
- [[equip_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `equip_user_cnt`

## 数据来源
- 宽表: [[ads_decismart_primary_cube_di]]
- dataset: ['300428']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **equip_start_battle_cnt** @ `mt_ads.ads_decismart_primary_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_primary_cube_di:equip_start_battle_cnt`(D 层未自动解析,待补)
- **equip_user_cnt** @ `mt_ads.ads_decismart_primary_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_primary_cube_di:equip_user_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: core-dau · tier: 长尾