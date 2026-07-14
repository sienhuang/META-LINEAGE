# MAU · mlbb  `MAU__mlbb__300088`

> 逻辑指标 [[MAU]] 在产品线 **mlbb** 的实例

- **公式**: `sum(active_cnt_period)`
- **业务口径**: 统计自然月内的去重活跃玩家数
- 宽表: test.ads_gamebi_roger_primary_di  (dataset 300088)
- dataset SQL: `mysql://ba/data_set#300088`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:154