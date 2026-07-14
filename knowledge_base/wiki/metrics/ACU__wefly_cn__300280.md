# ACU · wefly_cn  `ACU__wefly_cn__300280`

> 逻辑指标 [[ACU]] 在产品线 **wefly_cn** 的实例

- **公式**: `acu`
- **业务口径**: PCU：每5分钟的最大同时在线玩家数；
ACU：每5分钟的平均同时在线玩家数；
当全局筛选选择渠道或城市或剔除刷号选择「剔除刷号用户」时该看板数据不做展示
- 宽表: mt_ads_realtime.realtime_login  (dataset 300280)
- dataset SQL: `mysql://ba/data_set#300280`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnRealTime/Component/SecondaryIndicators/const.ts:157