# 新增玩家ARPU · zgame_cn  `新增玩家ARPU__zgame_cn__300302`

> 逻辑指标 [[新增玩家ARPU]] 在产品线 **zgame_cn** 的实例

- **公式**: `IF(sum(register_login_cnt) = 0, 0 , sum(register_pay_amt)/sum(register_login_cnt)/100)`
- **业务口径**: 当日新增玩家的付费金额/当日新增玩家数
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300302)
- dataset SQL: `mysql://ba/data_set#300302`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/Component/SecondaryIndicators/const.ts:68