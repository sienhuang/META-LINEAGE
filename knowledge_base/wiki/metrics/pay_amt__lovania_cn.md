# pay_amt · lovania_cn  `pay_amt__lovania_cn`

> 逻辑指标 [[pay_amt]] 在产品线 **lovania_cn** 的实例

- **公式**: `pay_amt * 0.01`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_login  (dataset 300400)
- dataset SQL: `mysql://ba/data_set#300400`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/Component/CascaderTable/const.ts:441