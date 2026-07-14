# create_role_day_cnt  `create_role_day_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(create_role_day_cnt)`

依赖的底层指标:
- [[create_role_day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `create_role_day_cnt`

## 数据来源
- 宽表: [[realtime_basic_create_role_retention]]
- dataset: ['300407']  · 产品线 scope: ['tgame', 'aoz', 'wefly5']

## 字段生成逻辑(D 层)
- **create_role_day_cnt** @ `mt_ads_realtime.realtime_basic_create_role_retention`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_create_role_retention:create_role_day_cnt`(D 层未自动解析,待补)

## 各产品线实例
- [[create_role_day_cnt__aoz__300407]] (scope=aoz, dataset=300407, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[create_role_day_cnt__tgame__300407]] (scope=tgame, dataset=300407, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[create_role_day_cnt__wefly5__300407]] (scope=wefly5, dataset=300407, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)

## 元信息
- 分类: other · tier: 长尾