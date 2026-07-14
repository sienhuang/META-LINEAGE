# register_cnt_ratio · wefly_cn  `register_cnt_ratio__wefly_cn`

> 逻辑指标 [[register_cnt_ratio]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(register_cnt) / SUM(sum(register_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300276)
- dataset SQL: `mysql://ba/data_set#300276`
- 维度: ['sub_channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/Component/CascaderTable/const.ts:404