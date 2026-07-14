# 渠道 · wefly_cn  `渠道__wefly_cn`

> 逻辑指标 [[渠道]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(pay_amt/100)/sum(pay_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_login  (dataset 300284)
- dataset SQL: `mysql://ba/data_set#300284`
- 维度: ['<dynamic>']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/Component/CascaderTable/const_countries.ts:437