# MAU · mlbb  `MAU__mlbb__300016`

> 逻辑指标 [[MAU]] 在产品线 **mlbb** 的实例

- **公式**: `cast(sum(indicator_map['mau']) as decimal(38,0))`
- **业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，月均DAU / MAU=(sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数)
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:102