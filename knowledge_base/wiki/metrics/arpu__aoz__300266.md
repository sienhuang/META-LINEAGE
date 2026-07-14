# arpu · aoz  `arpu__aoz__300266`

> 逻辑指标 [[arpu]] 在产品线 **aoz** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300266)
- dataset SQL: `mysql://ba/data_set#300266`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaOverview/Component/CascaderTable/const.ts:677