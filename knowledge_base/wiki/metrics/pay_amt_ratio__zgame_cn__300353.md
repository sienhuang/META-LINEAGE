# pay_amt_ratio · zgame_cn  `pay_amt_ratio__zgame_cn__300353`

> 逻辑指标 [[pay_amt_ratio]] 在产品线 **zgame_cn** 的实例

- **公式**: `avg(pay_amt) / SUM(avg(pay_amt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: ⚠️ 待P2  (dataset 300353)
- dataset SQL: `mysql://ba/data_set#300353`
- 维度: ['os']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/CascaderTable/const.ts:235