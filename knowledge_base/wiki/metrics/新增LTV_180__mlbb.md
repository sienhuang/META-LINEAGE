# 新增LTV_180 · mlbb  `新增LTV_180__mlbb`

> 逻辑指标 [[新增LTV_180]] 在产品线 **mlbb** 的实例

- **公式**: `sum(register_charge_day180)/sum(register_reten_cnt)/100`
- **业务口径**: LTV=新增玩家累计到第N天的付费金额/新增玩家数，单位为美元
- 宽表: test.ads_decismart_reten_ltv_di  (dataset 300085)
- dataset SQL: `mysql://ba/data_set#300085`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:338