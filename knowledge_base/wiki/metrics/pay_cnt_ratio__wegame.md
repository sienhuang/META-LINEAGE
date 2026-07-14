# pay_cnt_ratio · wegame  `pay_cnt_ratio__wegame`

> 逻辑指标 [[pay_cnt_ratio]] 在产品线 **wegame** 的实例

- **公式**: `avg(pay_cnt) / SUM(avg(pay_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300266)
- dataset SQL: `mysql://ba/data_set#300266`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyOverview/Component/CascaderTable/const.ts:441