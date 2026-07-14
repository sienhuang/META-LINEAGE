# 新增付费率 · zgame_cn  `新增付费率__zgame_cn__300350`

> 逻辑指标 [[新增付费率]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(pay_register_cnt)/sum(register_role_zone_cnt)`
- **业务口径**: 新增付费率：新增玩家在首日的付费率；新增玩家ARPU：当日新增玩家的付费金额/当日新增玩家数
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:899