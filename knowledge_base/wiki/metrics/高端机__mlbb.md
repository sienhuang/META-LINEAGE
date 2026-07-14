# 高端机 · mlbb  `高端机__mlbb`

> 逻辑指标 [[高端机]] 在产品线 **mlbb** 的实例

- **公式**: `sum(indicator_map['elec_ma_high'])/cast(sum(indicator_map['elec_battle_cnt_high']) as decimal(38,0))`
- **业务口径**: (角色各对局电流均值的和) / (角色战斗总场次) 单位为mA
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1164