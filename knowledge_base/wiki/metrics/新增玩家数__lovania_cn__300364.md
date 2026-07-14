# 新增玩家数 · lovania_cn  `新增玩家数__lovania_cn__300364`

> 逻辑指标 [[新增玩家数]] 在产品线 **lovania_cn** 的实例

- **公式**: `register_cnt`
- **业务口径**: 新注册的去重玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300364)
- dataset SQL: `mysql://ba/data_set#300364`
- 维度: —  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/const.ts:117