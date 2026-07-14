# 老用户7留率 · mlbb  `老用户7留率__mlbb`

> 逻辑指标 [[老用户7留率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(old_reten_day7)/sum(old_reten_day1)`
- **业务口径**: 老用户次留率：(T日新增天数>30日的活跃玩家数、且T+1日登录的去重玩家数) / (T日新增天数>30日的活跃玩家数) * 100%
老用户7留率：(T日新增天数>30日的活跃玩家数、且T+6日登录的去重玩家数) / (T日新增天数>30日的活跃玩家数) * 100%
老用户30留率：(T日新增天数>30日的活跃玩家数、且T+29日登录的去重玩家数) / (T日新增天数>30日的活跃玩家数) * 100%
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300012)
- dataset SQL: `mysql://ba/data_set#300012`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/MlbbDashboard/Component/SecondaryIndicators/const.ts:229