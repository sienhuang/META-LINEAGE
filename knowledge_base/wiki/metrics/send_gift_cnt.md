# send_gift_cnt  `send_gift_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `send_gift_cnt`

依赖的底层指标:
- [[send_gift_cnt]] (?) — `UNION_BRANCH_COLUMN[5]` [已确认] · 取数 `send_gift_cnt`

## 数据来源
- 宽表: [[ads_decismart_item_gift_di]]
- dataset: ['300432']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **send_gift_cnt** @ `mt_ads.ads_decismart_item_gift_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_item_gift_di.send_gift_cnt`):
    - d0 `mt_ads.ads_decismart_item_gift_di.send_gift_cnt` ⇐ `subquery:job.100053447_0:final_insert_branch_1.send_gift_cnt` [derived] `UNION_BRANCH_COLUMN[5]`
    - d0 `mt_ads.ads_decismart_item_gift_di.send_gift_cnt` ⇐ `subquery:job.100053447_0:final_insert_branch_2.send_gift_cnt` [derived] `UNION_BRANCH_COLUMN[5]`

## 元信息
- 分类: other · tier: 长尾