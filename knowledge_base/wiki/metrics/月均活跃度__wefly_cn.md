# 月均活跃度 · wefly_cn  `月均活跃度__wefly_cn`

> 逻辑指标 [[月均活跃度]] 在产品线 **wefly_cn** 的实例

- **公式**: `sum(indicator_map['avg_active_cnt'])/cast(sum(indicator_map['mau']) as decimal(38,0))`
- **业务口径**: 月度指标不受日期筛选器控制; 自然月粒度下，月均活跃度=月日均DAU / MAU=(sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数)
- 宽表: mt_ads.ads_gamebi_roger_secondary_di  (dataset 300202)
- dataset SQL: `mysql://ba/data_set#300202`
- 维度: ['logymd']  · 过滤: —
- 来源代码: src/views/WeflyCnOverview/Component/SecondaryIndicators/const.ts:144