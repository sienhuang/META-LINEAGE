# LTV30_3 · zgame_cn  `LTV30_3__zgame_cn__300354`

> 逻辑指标 [[LTV30_3]] 在产品线 **zgame_cn** 的实例

- **公式**: `(sum(register_charge_amt_30)/sum(register_reten_cnt_30_total))/(sum(register_charge_amt_3)/sum(register_reten_cnt_3_total))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: ⚠️ 待P2  (dataset 300354)
- dataset SQL: `mysql://ba/data_set#300354`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:557