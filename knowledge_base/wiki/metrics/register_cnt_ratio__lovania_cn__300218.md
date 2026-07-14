# register_cnt_ratio · lovania_cn  `register_cnt_ratio__lovania_cn__300218`

> 逻辑指标 [[register_cnt_ratio]] 在产品线 **lovania_cn** 的实例

- **公式**: `avg(register_cnt) / SUM(avg(register_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_reten_ltv_di  (dataset 300218)
- dataset SQL: `mysql://ba/data_set#300218`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnOverview/Component/CascaderTable/const.ts:294