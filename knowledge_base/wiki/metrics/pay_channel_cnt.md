# pay_channel_cnt  `pay_channel_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `pay_channel_cnt`

依赖的底层指标:
- [[pay_channel_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_channel_cnt`

## 数据来源
- 宽表: [[ads_decismart_pay_cube_di]]
- dataset: ['300092']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **pay_channel_cnt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:pay_channel_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: money · tier: 长尾