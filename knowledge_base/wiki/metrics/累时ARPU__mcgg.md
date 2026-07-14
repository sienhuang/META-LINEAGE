# 累时ARPU · mcgg  `累时ARPU__mcgg`

> 逻辑指标 [[累时ARPU]] 在产品线 **mcgg** 的实例

- **公式**: `sum(charge_day_amt)/sum(dau_day_cnt)/100`
- **业务口径**: (当日充值总美金金额) / (当日活跃玩家数)
- 宽表: mt_ads_realtime.realtime_login  (dataset 300109)
- dataset SQL: `mysql://ba/data_set#300109`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MCGGRealTime/Component/SecondaryIndicators/const.ts:16