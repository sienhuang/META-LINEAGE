# day_amt_ratio · wefly5  `day_amt_ratio__wefly5__300405`

> 逻辑指标 [[day_amt_ratio]] 在产品线 **wefly5** 的实例

- **公式**: `sum(day_amt) / SUM(sum(day_amt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_charge  (dataset 300405)
- dataset SQL: `mysql://ba/data_set#300405`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const.ts:437