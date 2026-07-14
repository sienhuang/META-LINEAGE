# register_cnt_ratio · zgame_cn  `register_cnt_ratio__zgame_cn__300351`

> 逻辑指标 [[register_cnt_ratio]] 在产品线 **zgame_cn** 的实例

- **公式**: `avg(register_cnt) / SUM(avg(register_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: ⚠️ 待P2  (dataset 300351)
- dataset SQL: `mysql://ba/data_set#300351`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/CascaderTable/const.ts:234