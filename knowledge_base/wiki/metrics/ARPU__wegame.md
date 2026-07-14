# arpu · wegame  `arpu__wegame`

> 逻辑指标 [[arpu]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_login  (dataset 300292)
- dataset SQL: `mysql://ba/data_set#300292`
- 维度: ['<dynamic>']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/Component/CascaderTable/const_countries.ts:362