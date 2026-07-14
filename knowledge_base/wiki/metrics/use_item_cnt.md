# use_item_cnt  `use_item_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `use_item_cnt`

依赖的底层指标:
- [[use_item_cnt]] (?) — `UNION_BRANCH_COLUMN[4]` [已确认] · 取数 `use_item_cnt`

## 数据来源
- 宽表: [[ads_decismart_primary_cube_di]], [[ads_decismart_item_interactive_effects_di]]
- dataset: ['300428', '300430']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **use_item_cnt** @ `mt_ads.ads_decismart_item_interactive_effects_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_item_interactive_effects_di.use_item_cnt`):
    - d0 `mt_ads.ads_decismart_item_interactive_effects_di.use_item_cnt` ⇐ `subquery:job.100053444_0:final_insert_branch_1.use_item_cnt` [derived] `UNION_BRANCH_COLUMN[4]`
    - d0 `mt_ads.ads_decismart_item_interactive_effects_di.use_item_cnt` ⇐ `subquery:job.100053444_0:final_insert_branch_2.use_item_cnt` [derived] `UNION_BRANCH_COLUMN[4]`

## 各产品线实例
- [[use_item_cnt__mlbb__300428]] (scope=mlbb, dataset=300428, 宽表=mt_ads.ads_decismart_primary_cube_di)
- [[use_item_cnt__mlbb__300430]] (scope=mlbb, dataset=300430, 宽表=mt_ads.ads_decismart_item_interactive_effects_di)

## 元信息
- 分类: core-dau · tier: 长尾