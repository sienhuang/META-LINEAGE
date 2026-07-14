# 付费率 · zgame_cn  `付费率__zgame_cn__300350`

> 逻辑指标 [[付费率]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(pay_cnt)/sum(active_cnt)`
- **业务口径**: 当天充值玩家数 / 当天活跃玩家数 * 100%
- 宽表: ⚠️ 待P2  (dataset 300350)
- dataset SQL: `mysql://ba/data_set#300350`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:803