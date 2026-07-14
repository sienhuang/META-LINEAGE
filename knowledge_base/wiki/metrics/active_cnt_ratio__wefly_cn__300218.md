# active_cnt_ratio · wefly_cn  `active_cnt_ratio__wefly_cn__300218`

> 逻辑指标 [[active_cnt_ratio]] 在产品线 **wefly_cn** 的实例

- **公式**: `avg(active_cnt) / SUM(avg(active_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_reten_ltv_di  (dataset 300218)
- dataset SQL: `mysql://ba/data_set#300218`
- 维度: ['sub_channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/Component/CascaderTable/const.ts:405