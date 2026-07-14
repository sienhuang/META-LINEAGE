# 进游率 · zgame_cn  `进游率__zgame_cn__300350`

> 逻辑指标 [[进游率]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(register_role_zone_cnt)/sum(register_cnt)`
- **业务口径**: 进游率 = 新增登录账号数 / 创建账号数 * 100%
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:399