# user_storage_download_complet_rate · mlbb  `user_storage_download_complet_rate__mlbb__300099`

> 逻辑指标 [[user_storage_download_complet_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(user_storage_download_complete_cnt)/sum(user_download_login_cnt) * 100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_performance_cube_di  (dataset 300099)
- dataset SQL: `mysql://ba/data_set#300099`
- 维度: ['region']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:329