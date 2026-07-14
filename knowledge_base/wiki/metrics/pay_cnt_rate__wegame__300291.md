# pay_cnt_rate · wegame  `pay_cnt_rate__wegame__300291`

> 逻辑指标 [[pay_cnt_rate]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_login  (dataset 300291)
- dataset SQL: `mysql://ba/data_set#300291`
- 维度: ['region']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyRealTime/Component/CascaderTable/const.ts:308