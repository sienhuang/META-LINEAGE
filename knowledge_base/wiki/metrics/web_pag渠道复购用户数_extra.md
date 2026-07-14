# web_pag渠道复购用户数_extra  `web_pag渠道复购用户数_extra`

**业务口径**: 统计周期内下单用户数14天内复购情况

## 怎么算
**公式**: `sum(web_pag) / if(max(sum_pay_user_cnt) > 0, max(sum_pay_user_cnt), 1)`

依赖的底层指标:
- [[sum_pay_user_cnt]] (?) — `⚠️待D层` [待补] · 取数 `sum_pay_user_cnt`
- [[web_pag]] (?) — `⚠️待D层` [待补] · 取数 `web_pag`

## 数据来源
- 宽表: [[dm_finance_user_channel_tz_di]]
- dataset: ['300331']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **sum_pay_user_cnt** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:sum_pay_user_cnt`(D 层未自动解析,待补)
- **web_pag** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:web_pag`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾