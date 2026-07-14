# 月日均DAU · wegame  `月日均DAU__wegame`

> 逻辑指标 [[月日均DAU]] 在产品线 **wegame** 的实例

- **公式**: `sum(indicator_map['avg_active_cnt'])`
- **业务口径**: 月度指标不受日期筛选器控制; 自然月粒度下，月均活跃度=月日均DAU / MAU=(sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数)
- 宽表: mt_ads.ads_gamebi_roger_secondary_di  (dataset 300256)
- dataset SQL: `mysql://ba/data_set#300256`
- 维度: ['logymd']  · 过滤: —
- 来源代码: src/views/WeflyOverview/Component/SecondaryIndicators/const.ts:144