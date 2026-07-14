# pay_cnt_rate · wefly_cn  `pay_cnt_rate__wefly_cn__300197`

> 逻辑指标 [[pay_cnt_rate]] 在产品线 **wefly_cn** 的实例

- **公式**: `if(sum(active_cnt) = 0, 0, sum(pay_cnt)/sum(active_cnt))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300197)
- dataset SQL: `mysql://ba/data_set#300197`
- 维度: ['<dynamic>']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/Component/CascaderTable/const_countries.ts:467