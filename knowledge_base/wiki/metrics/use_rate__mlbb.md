# use_rate · mlbb  `use_rate__mlbb`

> 逻辑指标 [[use_rate]] 在产品线 **mlbb** 的实例

- **公式**: `use_user_cnt/unlock_user_cnt*100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_primary_cube_di  (dataset 300428)
- dataset SQL: `mysql://ba/data_set#300428`
- 维度: ['item_id', 'item_name', 'item_type']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:1116