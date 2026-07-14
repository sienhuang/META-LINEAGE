# day_cnt_ratio  `day_cnt_ratio`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_cnt) / SUM(sum(day_cnt)) OVER ()`

依赖的底层指标:
- [[day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_cnt`

## 数据来源
- 宽表: [[realtime_basic_login]], [[realtime_basic_create_role]]
- dataset: ['300401', '300403']  · 产品线 scope: ['tgame', 'aoz', 'wefly5']

## 字段生成逻辑(D 层)
- **day_cnt** @ `mt_ads_realtime.realtime_basic_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_login:day_cnt`(D 层未自动解析,待补)

## 各产品线实例
- [[day_cnt_ratio__aoz__300401]] (scope=aoz, dataset=300401, 宽表=mt_ads_realtime.realtime_basic_login)
- [[day_cnt_ratio__aoz__300403]] (scope=aoz, dataset=300403, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[day_cnt_ratio__tgame__300401]] (scope=tgame, dataset=300401, 宽表=mt_ads_realtime.realtime_basic_login)
- [[day_cnt_ratio__tgame__300403]] (scope=tgame, dataset=300403, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[day_cnt_ratio__wefly5__300401]] (scope=wefly5, dataset=300401, 宽表=mt_ads_realtime.realtime_basic_login)
- [[day_cnt_ratio__wefly5__300403]] (scope=wefly5, dataset=300403, 宽表=mt_ads_realtime.realtime_basic_create_role)

## 元信息
- 分类: other · tier: 长尾