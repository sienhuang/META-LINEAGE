# 流水金额 · mlbb  `流水金额__mlbb`

> 逻辑指标 [[流水金额]] 在产品线 **mlbb** 的实例

- **公式**: `product_money/100`
- **业务口径**: 游戏整体美金定价流水数据
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300311)
- dataset SQL: `mysql://ba/data_set#300311`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/PayPlatformOverview/const.ts:22