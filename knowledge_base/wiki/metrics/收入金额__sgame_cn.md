# 收入金额 · sgame_cn  `收入金额__sgame_cn`

> 逻辑指标 [[收入金额]] 在产品线 **sgame_cn** 的实例

- **公式**: `pay_amt/100`
- **业务口径**: 玩家充值金额，单位为元
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300364)
- dataset SQL: `mysql://ba/data_set#300364`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/const.ts:159