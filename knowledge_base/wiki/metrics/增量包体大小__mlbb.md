# 增量包体大小 · mlbb  `增量包体大小__mlbb`

> 逻辑指标 [[增量包体大小]] 在产品线 **mlbb** 的实例

- **公式**: `sum(indicator_map['gamepackage_size'])/1024`
- **业务口径**: 每日玩家的增量包体中位数 单位为G，数据可计算最早时间为 2023-07-01
- 宽表: test.ads_gamebi_roger_secondary_cube_di  (dataset 300017)
- dataset SQL: `mysql://ba/data_set#300017`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1331