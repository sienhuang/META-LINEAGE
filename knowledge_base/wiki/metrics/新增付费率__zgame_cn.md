# 新增付费率 · zgame_cn  `新增付费率__zgame_cn`

> 逻辑指标 [[新增付费率]] 在产品线 **zgame_cn** 的实例

- **公式**: `IF(sum(register_login_cnt) = 0, 0 , sum(register_pay_cnt)/sum(register_login_cnt))`
- **业务口径**: 新增玩家在首日的付费率
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300302)
- dataset SQL: `mysql://ba/data_set#300302`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/Component/SecondaryIndicators/const.ts:20