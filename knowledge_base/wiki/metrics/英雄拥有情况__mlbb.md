# 英雄拥有情况 · mlbb  `英雄拥有情况__mlbb`

> 逻辑指标 [[英雄拥有情况]] 在产品线 **mlbb** 的实例

- **公式**: `active_cnt`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_gamebi_roger_resource_cube_di  (dataset 300055)
- dataset SQL: `mysql://ba/data_set#300055`
- 维度: ['heroid']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MlbbDashboard/Component/SecondaryIndicators/const.ts:480