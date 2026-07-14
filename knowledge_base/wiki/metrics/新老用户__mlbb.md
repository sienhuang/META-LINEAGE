# 新老用户 · mlbb  `新老用户__mlbb`

> 逻辑指标 [[新老用户]] 在产品线 **mlbb** 的实例

- **公式**: `sum(user_storage_download_complete_cnt)/sum(user_download_login_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: test.ads_decismart_performance_cube_di  (dataset 300104)
- dataset SQL: `mysql://ba/data_set#300104`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:900