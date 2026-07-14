# 6g（32位） · mlbb  `6g（32位）__mlbb`

> 逻辑指标 [[6g（32位）]] 在产品线 **mlbb** 的实例

- **公式**: `sum(indicator_map['memory_pss_6g_greater_32bit'])/cast(sum(indicator_map['memory_battle_cnt_6g_greater_32bit']) as decimal(38,0))`
- **业务口径**: 角色当日各对局内存求和 / 角色战斗总场次  单位为M
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300205)
- dataset SQL: `mysql://ba/data_set#300205`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1080