# active_cnt_kpi  `active_cnt_kpi`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `active_cnt_kpi`

依赖的底层指标:
- [[active_cnt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt_kpi`

## 数据来源
- 宽表: [[realtime_basic_charge]]
- dataset: ['300409']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **active_cnt_kpi** @ `mt_ads_realtime.realtime_basic_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_charge:active_cnt_kpi`(D 层未自动解析,待补)

## 元信息
- 分类: core-dau · tier: 长尾