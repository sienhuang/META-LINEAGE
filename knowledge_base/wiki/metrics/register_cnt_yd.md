# register_cnt_yd  `register_cnt_yd`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(register_cnt_yd)`

依赖的底层指标:
- [[register_cnt_yd]] (?) — `⚠️待D层` [待补] · 取数 `register_cnt_yd`

## 数据来源
- 宽表: [[ads_mlbb_realtime_batch_data_di]], [[realtime_login]]
- dataset: ['300366', '300400']  · 产品线 scope: ['lovania_cn', 'sgame_cn']

## 字段生成逻辑(D 层)
- **register_cnt_yd** @ `mt_ads_realtime.ads_mlbb_realtime_batch_data_di`
  - 口径指针: `etl://mt_ads_realtime.ads_mlbb_realtime_batch_data_di:register_cnt_yd`(D 层未自动解析,待补)

## 各产品线实例
- [[register_cnt_yd__lovania_cn__300366]] (scope=lovania_cn, dataset=300366, 宽表=mt_ads_realtime.ads_mlbb_realtime_batch_data_di)
- [[register_cnt_yd__lovania_cn__300400]] (scope=lovania_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)
- [[register_cnt_yd__sgame_cn__300366]] (scope=sgame_cn, dataset=300366, 宽表=mt_ads_realtime.ads_mlbb_realtime_batch_data_di)
- [[register_cnt_yd__sgame_cn__300400]] (scope=sgame_cn, dataset=300400, 宽表=mt_ads_realtime.realtime_login)

## 元信息
- 分类: register · tier: 长尾