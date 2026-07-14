# 月度2美金付费率 · mlbb  `月度2美金付费率__mlbb`

> 逻辑指标 [[月度2美金付费率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(indicator_map['2usd_pay_cnt'])/cast(sum(indicator_map['avg_active_cnt']) as decimal(38,0))`
- **业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，(当月累计付费达2美金的玩家数) / (月均DAU) * 100%
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:511