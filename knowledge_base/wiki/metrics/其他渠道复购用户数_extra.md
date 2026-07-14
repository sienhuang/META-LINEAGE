# 其他渠道复购用户数_extra  `其他渠道复购用户数_extra`

**业务口径**: 统计周期内下单用户数14天内复购情况

## 怎么算
**公式**: `sum(other) / if(max(sum_pay_user_cnt) > 0, max(sum_pay_user_cnt), 1)`

依赖的底层指标:
- [[other]] (?) — `⚠️待D层` [待补] · 取数 `other`
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`

## 数据来源
- 宽表: [[dm_finance_user_channel_tz_di]]
- dataset: ['300331']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **other** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:other`(D 层未自动解析,待补)
- **sum_pay_user_cnt** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:sum_pay_user_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾