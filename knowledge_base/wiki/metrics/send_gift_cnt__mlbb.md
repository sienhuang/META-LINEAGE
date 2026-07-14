# send_gift_cnt · mlbb  `send_gift_cnt__mlbb`

> 逻辑指标 [[send_gift_cnt]] 在产品线 **mlbb** 的实例

- **公式**: `send_gift_cnt`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_item_gift_di  (dataset 300432)
- dataset SQL: `mysql://ba/data_set#300432`
- 维度: ['item_id']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:1744