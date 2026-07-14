# arpu · wefly2  `arpu__wefly2__300263`

> 逻辑指标 [[arpu]] 在产品线 **wefly2** 的实例

- **公式**: `sum(pay_amt/100)/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300263)
- dataset SQL: `mysql://ba/data_set#300263`
- 维度: ['region']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/Wefly2Overview/Component/CascaderTable/const.ts:453