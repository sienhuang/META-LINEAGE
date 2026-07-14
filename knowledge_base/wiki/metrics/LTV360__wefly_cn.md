# LTV360 · wefly_cn  `LTV360__wefly_cn`

> 逻辑指标 [[LTV360]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(register_charge_amt_360)/100/sum(register_reten_cnt_360_total)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300201)
- dataset SQL: `mysql://ba/data_set#300201`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/Component/SecondaryIndicators/const.ts:376