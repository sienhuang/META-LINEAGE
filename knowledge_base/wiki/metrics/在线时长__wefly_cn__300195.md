# 在线时长 · wefly_cn  `在线时长__wefly_cn__300195`

> 逻辑指标 [[在线时长]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(online_dur)/sum(active_cnt)/60`
- **业务口径**: 玩家当天人均在线时长，单位为分钟
- 宽表: ⚠️ 待P2  (dataset 300195)
- dataset SQL: `mysql://ba/data_set#300195`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyCnOverview/Component/SecondaryIndicators/const.ts:102