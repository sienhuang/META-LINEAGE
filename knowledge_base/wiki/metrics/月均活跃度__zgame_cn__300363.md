# 月均活跃度 · zgame_cn  `月均活跃度__zgame_cn__300363`

> 逻辑指标 [[月均活跃度]] 在产品线 **zgame_cn** 的实例

- **公式**: `sum(indicator_map['avg_active_cnt'])/cast(sum(indicator_map['mau']) as decimal(38,0))`
- **业务口径**: 月度指标不受日期筛选器控制; 自然月粒度下，月均活跃度=月日均DAU / MAU * 100% = (sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数) * 100%
- 宽表: mt_ads_realtime.realtime_recurring  (dataset 300363)
- dataset SQL: `mysql://ba/data_set#300363`
- 维度: ['logymd']  · 过滤: —
- 来源代码: src/views/ZgameCnOverview/Component/SecondaryIndicators/const.ts:66