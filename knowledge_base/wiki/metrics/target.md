# target  `target`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `target_node`

依赖的底层指标:
- [[target_node]] (?) — `⚠️待D层` [待补] · 取数 `target_node`

## 数据来源
- 宽表: [[dm_finance_user_channel_tz_di]]
- dataset: ['300360']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **target_node** @ `mt_dm.dm_finance_user_channel_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_user_channel_tz_di:target_node`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾