# 卡loading率  `卡loading率`

**业务口径**: battleloading阶段卡死没有正常结束loading进入到战斗中的比例

## 怎么算
**公式**: `sum(loading_cnt)/sum(loading_total_cnt)`

依赖的底层指标:
- [[loading_cnt]] (?) — `⚠️待D层` [待补] · 取数 `loading_cnt`
- [[loading_total_cnt]] (?) — `⚠️待D层` [待补] · 取数 `loading_total_cnt`

## 数据来源
- 宽表: [[ads_decismart_performance_cube_di]]
- dataset: ['300099']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **loading_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:loading_cnt`(D 层未自动解析,待补)
- **loading_total_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:loading_total_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾