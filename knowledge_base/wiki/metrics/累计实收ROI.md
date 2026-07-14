# 累计实收ROI  `累计实收ROI`

**业务口径**: 累计实收ROI

## 怎么算
**公式**: `sum(total_actual_amt)/sum(consume_amt)`

依赖的底层指标:
- [[consume_amt]] (?) — `⚠️待D层` [待补] · 取数 `consume_amt`
- [[total_actual_amt]] (?) — `⚠️待D层` [待补] · 取数 `total_actual_amt`

## 数据来源
- 宽表: [[realtime_basic_online]]
- dataset: ['300408']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **consume_amt** @ `mt_ads_realtime.realtime_basic_online`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_online:consume_amt`(D 层未自动解析,待补)
- **total_actual_amt** @ `mt_ads_realtime.realtime_basic_online`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_online:total_actual_amt`(D 层未自动解析,待补)

## 元信息
- 分类: money · tier: 长尾