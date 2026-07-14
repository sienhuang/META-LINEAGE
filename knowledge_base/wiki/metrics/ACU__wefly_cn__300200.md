# ACU · wefly_cn  `ACU__wefly_cn__300200`

> 逻辑指标 [[ACU]] 在产品线 **wefly_cn** 的实例

- **公式**: `acu`
- **业务口径**: PCU: 最大同时在线玩家数
ACU: 平均同时在线玩家数
当全局筛选选择渠道或城市，或剔除刷号选择“是”时该看板数据不做展示
- 宽表: mt_ads.ads_gamebi_roger_primary_cube_di  (dataset 300200)
- dataset SQL: `mysql://ba/data_set#300200`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/Component/SecondaryIndicators/const.ts:240