# 新增玩家ARPU  `新增玩家ARPU`

**业务口径**: 新增付费率：新增玩家在首日的付费率；新增玩家ARPU：当日新增玩家的付费金额/当日新增玩家数

## 怎么算
**公式**: `sum(pay_register_amt)/100/sum(register_role_zone_cnt)`

依赖的底层指标:
- [[pay_register_amt]] (?) — `⚠️待D层` [待补] · 取数 `pay_register_amt`
- [[register_role_zone_cnt]] (?) — `⚠️待D层` [待补] · 取数 `register_role_zone_cnt`
- [[register_login_cnt]] (?) — `⚠️待D层` [待补] · 取数 `register_login_cnt`
- [[register_pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `register_pay_amt`

## 数据来源
- 宽表: [[ads_realtime_batch_data_di]]
- dataset: ['300350', '300302']  · 产品线 scope: ['zgame_cn']

## 字段生成逻辑(D 层)
- **register_login_cnt** @ `mt_ads_realtime.ads_realtime_batch_data_di`
  - 口径指针: `etl://mt_ads_realtime.ads_realtime_batch_data_di:register_login_cnt`(D 层未自动解析,待补)
- **register_pay_amt** @ `mt_ads_realtime.ads_realtime_batch_data_di`
  - 口径指针: `etl://mt_ads_realtime.ads_realtime_batch_data_di:register_pay_amt`(D 层未自动解析,待补)

## 各产品线实例
- [[新增玩家ARPU__zgame_cn__300350]] (scope=zgame_cn, dataset=300350, 宽表=—)
- [[新增玩家ARPU__zgame_cn__300302]] (scope=zgame_cn, dataset=300302, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: register · tier: 长尾