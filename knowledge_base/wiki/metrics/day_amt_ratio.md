# day_amt_ratio  `day_amt_ratio`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_amt) / SUM(sum(day_amt)) OVER ()`

依赖的底层指标:
- [[day_amt]] (?) — `⚠️待D层` [待补] · 取数 `day_amt`

## 数据来源
- 宽表: [[realtime_basic_charge]]
- dataset: ['300405']  · 产品线 scope: ['tgame', 'aoz', 'wefly5']

## 字段生成逻辑(D 层)
- **day_amt** @ `mt_ads_realtime.realtime_basic_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_charge:day_amt`(D 层未自动解析,待补)

## 各产品线实例
- [[day_amt_ratio__aoz__300405]] (scope=aoz, dataset=300405, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[day_amt_ratio__tgame__300405]] (scope=tgame, dataset=300405, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[day_amt_ratio__wefly5__300405]] (scope=wefly5, dataset=300405, 宽表=mt_ads_realtime.realtime_basic_charge)

## 元信息
- 分类: other · tier: 长尾