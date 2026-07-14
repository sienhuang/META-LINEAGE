# 登录渠道 · wegame  `登录渠道__wegame`

> 逻辑指标 [[登录渠道]] 在产品线 **wegame** 的实例

- **公式**: `sum(pay_amt/100)/sum(pay_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300266)
- dataset SQL: `mysql://ba/data_set#300266`
- 维度: ['<dynamic>']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyOverview/Component/CascaderTable/const_countries.ts:452