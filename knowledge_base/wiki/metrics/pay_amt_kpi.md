# pay_amt_kpi  `pay_amt_kpi`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `pay_amt_kpi * 0.01`

依赖的底层指标:
- [[pay_amt_kpi]] (?) — `⚠️待D层` [待补] · 取数 `pay_amt_kpi`

## 数据来源
- 宽表: [[realtime_basic_charge]]
- dataset: ['300409']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **pay_amt_kpi** @ `mt_ads_realtime.realtime_basic_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_charge:pay_amt_kpi`(D 层未自动解析,待补)

## 元信息
- 分类: money · tier: 长尾