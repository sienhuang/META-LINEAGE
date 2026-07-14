# 人均在线时长 · zgame_cn  `人均在线时长__zgame_cn`

> 逻辑指标 [[人均在线时长]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(online_dur)/sum(active_cnt)/60`
- **业务口径**: 玩家当天人均在线时长，单位为分钟
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:24