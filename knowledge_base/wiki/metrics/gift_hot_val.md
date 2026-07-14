# gift_hot_val  `gift_hot_val`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `gift_hot_val`

依赖的底层指标:
- [[gift_hot_val]] (?) — `UNION_BRANCH_COLUMN[7]` [已确认] · 取数 `gift_hot_val`

## 数据来源
- 宽表: [[ads_decismart_item_gift_di]]
- dataset: ['300432']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **gift_hot_val** @ `mt_ads.ads_decismart_item_gift_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_item_gift_di.gift_hot_val`):
    - d0 `mt_ads.ads_decismart_item_gift_di.gift_hot_val` ⇐ `subquery:job.100053447_0:final_insert_branch_1.gift_hot_val` [derived] `UNION_BRANCH_COLUMN[7]`
    - d0 `mt_ads.ads_decismart_item_gift_di.gift_hot_val` ⇐ `subquery:job.100053447_0:final_insert_branch_2.gift_hot_val` [derived] `UNION_BRANCH_COLUMN[7]`

## 元信息
- 分类: other · tier: 长尾