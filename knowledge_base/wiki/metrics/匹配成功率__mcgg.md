# 匹配成功率 · mcgg  `匹配成功率__mcgg`

> 逻辑指标 [[匹配成功率]] 在产品线 **mcgg** 的实例

- **公式**: `SUM(indicator_map['match_success_cnt_39'] + indicator_map['match_success_cnt_201'] + indicator_map['match_success_cnt_301'] + indicator_map['match_success_cnt_170'] ) / cast(SUM(indicator_map['match_battle_cnt_39'] + indicator_map['match_battle_cnt_201'] + indicator_map['match_battle_cnt_301'] + indicator_map['match_battle_cnt_170']) as decimal(38,0))`
- **业务口径**: 今日匹配成功的战局 / 总匹配战局 * 100%，爽局模式2025-04-22开启
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:750