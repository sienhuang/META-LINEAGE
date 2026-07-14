# unlock_item_cnt  `unlock_item_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `unlock_item_cnt`

依赖的底层指标:
- [[unlock_item_cnt]] (?) — `unlock_item_cnt` [已确认] · 取数 `unlock_item_cnt`

## 数据来源
- 宽表: [[ads_decismart_item_info_di]]
- dataset: ['300425']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **unlock_item_cnt** @ `mt_ads.ads_decismart_item_info_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_item_info_di.unlock_item_cnt`):
    - d0 `mt_ads.ads_decismart_item_info_di.unlock_item_cnt` ⇐ `subquery:job.100053443_1:tk.unlock_item_cnt` [direct] `unlock_item_cnt`
    - d1 `subquery:job.100053443_1:tk.unlock_item_cnt` ⇐ `cte:job.100053443_1:get_detail_agg.unlock_item_cnt` [aggregated] `COALESCE(SUM(get_detail_agg.unlock_item_cnt), 0) AS unlock_item_cnt`

## 元信息
- 分类: other · tier: 长尾