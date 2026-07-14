# pay_cnt_rate · wegame  `pay_cnt_rate__wegame__300263`

> 逻辑指标 [[pay_cnt_rate]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300263)
- dataset SQL: `mysql://ba/data_set#300263`
- 维度: ['region']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyOverview/Component/CascaderTable/const.ts:442