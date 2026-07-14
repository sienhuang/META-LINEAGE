# coda渠道复购用户数  `coda渠道复购用户数`

**业务口径**: 统计周期内下单用户数14天内复购情况

## 怎么算
**公式**: `coda`

依赖的底层指标:
- [[coda]] (?) — `⚠️待D层` [待补] · 取数 `coda`

## 数据来源
- 宽表: [[dm_finance_user_channel_tz_di]]
- dataset: ['300331']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **coda** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:coda`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾