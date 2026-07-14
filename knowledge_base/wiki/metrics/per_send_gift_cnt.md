# per_send_gift_cnt  `per_send_gift_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `avg(send_gift_cnt)/avg(send_gift_user_cnt)`

依赖的底层指标:
- [[send_gift_cnt]] (?) — `UNION_BRANCH_COLUMN[5]` [已确认] · 取数 `send_gift_cnt`
- [[send_gift_user_cnt]] (?) — `UNION_BRANCH_COLUMN[4]` [已确认] · 取数 `send_gift_user_cnt`

## 数据来源
- 宽表: [[ads_decismart_item_gift_di]]
- dataset: ['300432']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **send_gift_cnt** @ `mt_ads.ads_decismart_item_gift_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_item_gift_di.send_gift_cnt`):
    - d0 `mt_ads.ads_decismart_item_gift_di.send_gift_cnt` ⇐ `subquery:job.100053447_0:final_insert_branch_1.send_gift_cnt` [derived] `UNION_BRANCH_COLUMN[5]`
    - d0 `mt_ads.ads_decismart_item_gift_di.send_gift_cnt` ⇐ `subquery:job.100053447_0:final_insert_branch_2.send_gift_cnt` [derived] `UNION_BRANCH_COLUMN[5]`
- **send_gift_user_cnt** @ `mt_ads.ads_decismart_item_gift_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_item_gift_di.send_gift_user_cnt`):
    - d0 `mt_ads.ads_decismart_item_gift_di.send_gift_user_cnt` ⇐ `subquery:job.100053447_0:final_insert_branch_1.send_gift_user_cnt` [derived] `UNION_BRANCH_COLUMN[4]`
    - d0 `mt_ads.ads_decismart_item_gift_di.send_gift_user_cnt` ⇐ `subquery:job.100053447_0:final_insert_branch_2.send_gift_user_cnt` [derived] `UNION_BRANCH_COLUMN[4]`
    - d1 `subquery:job.100053447_0:final_insert_branch_1.send_gift_user_cnt` ⇐ `ml_ods.gameserver_social_send_gift.roleid` [aggregated] `COUNT(DISTINCT g.roleid) AS send_gift_user_cnt`
    - d1 `subquery:job.100053447_0:final_insert_branch_2.send_gift_user_cnt` ⇐ `ml_ods.gameserver_social_send_gift.roleid` [aggregated] `COUNT(DISTINCT g.roleid) AS send_gift_user_cnt`

## 元信息
- 分类: other · tier: 长尾