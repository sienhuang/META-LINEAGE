# PCU · zgame_cn  `PCU__zgame_cn__300355`

> 逻辑指标 [[PCU]] 在产品线 **zgame_cn** 的实例

- **公式**: `pcu`
- **业务口径**: PCU: 最大同时在线玩家数；ACU: 平均同时在线玩家数（仅可计算全量用户下，单一国家/操作系统/区服的数据，选择其他维度时该看板数据不做显示）
- 宽表: ⚠️ 待P2  (dataset 300355)
- dataset SQL: `mysql://ba/data_set#300355`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:161