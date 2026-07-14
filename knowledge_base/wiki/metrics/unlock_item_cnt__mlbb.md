# unlock_item_cnt · mlbb  `unlock_item_cnt__mlbb`

> 逻辑指标 [[unlock_item_cnt]] 在产品线 **mlbb** 的实例

- **公式**: `unlock_item_cnt`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_item_info_di  (dataset 300425)
- dataset SQL: `mysql://ba/data_set#300425`
- 维度: ['item_id']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:933