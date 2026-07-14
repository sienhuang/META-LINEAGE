# value · lovania_cn  `value__lovania_cn`

> 逻辑指标 [[value]] 在产品线 **lovania_cn** 的实例

- **公式**: `sum(register_reten2)/sum(register_cnt_yd)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_dm.dm_finance_role_zone_tz_di  (dataset 300365)
- dataset SQL: `mysql://ba/data_set#300365`
- 维度: ['logymd', 'point']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonCnRealTime/const.ts:241