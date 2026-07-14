# ping均值 · mcgg  `ping均值__mcgg`

> 逻辑指标 [[ping均值]] 在产品线 **mcgg** 的实例

- **公式**: `SUM(indicator_map['network_timedelay_cnt']) / cast(SUM(indicator_map['network_battle_cnt']) as decimal(38,0))`
- **业务口径**: 玩家单局战斗的ping的均值
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:662