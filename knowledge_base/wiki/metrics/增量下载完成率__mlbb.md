# 增量下载完成率 · mlbb  `增量下载完成率__mlbb`

> 逻辑指标 [[增量下载完成率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(user_storage_download_complete_cnt)/sum(user_download_login_cnt)`
- **业务口径**: (T日增量下载完成角色数 + T日增量下载未完成但 [T+1: T+2] 首次登录时增量下载完成的角色数）/ (T日登录总角色数) * 100%
- 宽表: mt_ads_pre.ads_decismart_performance_cube_di  (dataset 300098)
- dataset SQL: `mysql://ba/data_set#300098`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/InfrastructureOverview/const.ts:245