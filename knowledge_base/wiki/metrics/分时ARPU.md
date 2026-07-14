# 分时ARPU  `分时ARPU`

**业务口径**: (当日充值总美金金额) / (当日活跃玩家数)

## 怎么算
**公式**: `sum(charge_point_amt)/sum(dau_point_cnt)/100`

依赖的底层指标:
- [[charge_point_amt]] (?) — `⚠️待D层` [待补] · 取数 `charge_point_amt`
- [[dau_point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `dau_point_cnt`

## 数据来源
- 宽表: [[realtime_login]]
- dataset: ['300109']  · 产品线 scope: ['mcgg']

## 字段生成逻辑(D 层)
- **charge_point_amt** @ `mt_ads_realtime.realtime_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_login:charge_point_amt`(D 层未自动解析,待补)
- **dau_point_cnt** @ `mt_ads_realtime.realtime_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_login:dau_point_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: core-dau · tier: 长尾