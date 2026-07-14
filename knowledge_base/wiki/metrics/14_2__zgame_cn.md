# 14_2 · zgame_cn  `14_2__zgame_cn`

> 逻辑指标 [[14_2]] 在产品线 **zgame_cn** 的实例

- **公式**: `(sum(register_reten_cnt_14)/sum(register_reten_cnt_14_total))/(sum(register_reten_cnt_2)/sum(register_reten_cnt_2_total))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: ⚠️ 待P2  (dataset 300356)
- dataset SQL: `mysql://ba/data_set#300356`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:321