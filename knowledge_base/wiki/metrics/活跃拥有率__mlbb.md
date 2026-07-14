# 活跃拥有率 · mlbb  `活跃拥有率__mlbb`

> 逻辑指标 [[活跃拥有率]] 在产品线 **mlbb** 的实例

- **公式**: `ifnull(sum(resoure_active_cnt) / sum(active_cnt), 0)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_skin_info_test  (dataset 300054)
- dataset SQL: `mysql://ba/data_set#300054`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MlbbDashboard/Component/SecondaryIndicators/const.ts:721