# 在线时长 · mcgg  `在线时长__mcgg`

> 逻辑指标 [[在线时长]] 在产品线 **mcgg** 的实例

- **公式**: `sum(online_dur)/sum(active_cnt)/60`
- **业务口径**: 玩家当天人均在线时长，单位为分钟
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300197)
- dataset SQL: `mysql://ba/data_set#300197`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:121