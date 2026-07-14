# 全部资源转化情况  `all_resource_conversion`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `use_user_cnt/unlock_user_cnt*100`

依赖的底层指标:
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[distribution_channel]] (?) — `⚠️待D层` [待补] · 取数 `distribution_channel`
- [[equip_hero_cnt]] (?) — `⚠️待D层` [待补] · 取数 `equip_hero_cnt`
- [[equip_start_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `equip_start_battle_cnt`
- [[equip_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `equip_user_cnt`
- [[funnel_type]] (?) — `⚠️待D层` [待补] · 取数 `funnel_type`
- [[item_quality]] (?) — `⚠️待D层` [待补] · 取数 `item_quality`
- [[item_type_name]] (?) — `⚠️待D层` [待补] · 取数 `item_type_name`
- [[unlock_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `unlock_user_cnt`
- [[use_item_cnt]] (?) — `⚠️待D层` [待补] · 取数 `use_item_cnt`
- [[use_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `use_user_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300428'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:1116