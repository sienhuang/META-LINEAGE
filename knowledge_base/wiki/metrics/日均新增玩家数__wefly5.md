# 日均新增玩家数 · wefly5  `日均新增玩家数__wefly5`

> 逻辑指标 [[日均新增玩家数]] 在产品线 **wefly5** 的实例

- **公式**: `register_cnt`
- **业务口径**: (所选日期按天新增玩家数加和)/(所选日期的总天数)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300005)
- dataset SQL: `mysql://ba/data_set#300005`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaOverview/const.ts:102