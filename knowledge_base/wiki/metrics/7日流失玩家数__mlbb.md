# 7日流失玩家数 · mlbb  `7日流失玩家数__mlbb`

> 逻辑指标 [[7日流失玩家数]] 在产品线 **mlbb** 的实例

- **公式**: `sum(lose_cnt_7ds)`
- **业务口径**: 7日玩家流失率：7日流失人数/7日前DAU；
7日流失玩家数：T-7当天有登录、且T-6~T期间未登录玩家/T-7当天登录玩家；
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300086)
- dataset SQL: `mysql://ba/data_set#300086`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:636