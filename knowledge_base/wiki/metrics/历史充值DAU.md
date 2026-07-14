# 历史充值DAU  `历史充值DAU`

**业务口径**: 当日活跃且历史有过充值的玩家数

## 怎么算
**公式**: `sum(his_pay_active_cnt)`

依赖的底层指标:
- [[his_pay_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `his_pay_active_cnt`
- [[pay_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_active_cnt`

## 数据来源
- 宽表: [[ads_decismart_pay_cube_di]]
- dataset: ['300089', '300350']  · 产品线 scope: ['mlbb', 'zgame_cn']

## 字段生成逻辑(D 层)
- **his_pay_active_cnt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_pay_cube_di:his_pay_active_cnt`(D 层未自动解析,待补)

## 各产品线实例
- [[历史充值DAU__mlbb__300089]] (scope=mlbb, dataset=300089, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[历史充值DAU__zgame_cn__300350]] (scope=zgame_cn, dataset=300350, 宽表=—)

## 元信息
- 分类: core-dau · tier: 长尾