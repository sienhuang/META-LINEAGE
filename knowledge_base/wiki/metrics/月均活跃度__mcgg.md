# 月均活跃度 · mcgg  `月均活跃度__mcgg`

> 逻辑指标 [[月均活跃度]] 在产品线 **mcgg** 的实例

- **公式**: `sum(monthly_activity_ratio)`
- **业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，月均DAU / MAU=(sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数)
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300198)
- dataset SQL: `mysql://ba/data_set#300198`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:71