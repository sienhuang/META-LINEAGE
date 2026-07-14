# 新增玩家次留 · zgame_cn  `新增玩家次留__zgame_cn`

> 逻辑指标 [[新增玩家次留]] 在产品线 **zgame_cn** 的实例

- **公式**: `IF(sum(register_cnt_yd) = 0, 0 , sum(register_reten2)/sum(register_cnt_yd))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300302)
- dataset SQL: `mysql://ba/data_set#300302`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/Component/SecondaryIndicators/const.ts:115