# ARPU · sgame_cn  `ARPU__sgame_cn__300364`

> 逻辑指标 [[ARPU]] 在产品线 **sgame_cn** 的实例

- **公式**: `sum(pay_amt)/100/sum(active_cnt)`
- **业务口径**: 充值总金额 / 活跃玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300364)
- dataset SQL: `mysql://ba/data_set#300364`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/const.ts:201