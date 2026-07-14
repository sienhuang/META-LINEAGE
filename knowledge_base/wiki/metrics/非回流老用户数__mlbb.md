# 非回流老用户数 · mlbb  `非回流老用户数__mlbb`

> 逻辑指标 [[非回流老用户数]] 在产品线 **mlbb** 的实例

- **公式**: `active_cnt-new_active_cnt-recurring_cnt_30days`
- **业务口径**: 30日回流活跃玩家数：当日登录过，且流失天数>=30的去重玩家数；
新用户活跃玩家数：新增<=30天，且在当天有登录日志的去重玩家数；
非回流老用户活跃玩家数：非30日回流玩家，且新增>30天，且在当天有登录日志的去重玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300086)
- dataset SQL: `mysql://ba/data_set#300086`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:17