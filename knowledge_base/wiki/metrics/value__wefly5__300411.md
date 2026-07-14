# value · wefly5  `value__wefly5__300411`

> 逻辑指标 [[value]] 在产品线 **wefly5** 的实例

- **公式**: `sum(login_day_cnt)/sum(create_role_day_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_create_role_retention  (dataset 300411)
- dataset SQL: `mysql://ba/data_set#300411`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/const.ts:247