# pay_cnt_rate · wefly_cn  `pay_cnt_rate__wefly_cn__300276`

> 逻辑指标 [[pay_cnt_rate]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_create_role  (dataset 300276)
- dataset SQL: `mysql://ba/data_set#300276`
- 维度: ['sub_channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/Component/CascaderTable/const.ts:407