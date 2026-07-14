# pay_cnt · wegame  `pay_cnt__wegame__300293`

> 逻辑指标 [[pay_cnt]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_charge_cnt  (dataset 300293)
- dataset SQL: `mysql://ba/data_set#300293`
- 维度: ['region']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/Component/CascaderTable/const.ts:310