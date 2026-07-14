# 广告新增玩家数 · mlbb  `广告新增玩家数__mlbb`

> 逻辑指标 [[广告新增玩家数]] 在产品线 **mlbb** 的实例

- **公式**: `sum(non_natural_register_cnt)`
- **业务口径**: 自然新增玩家数：当天注册的自然新增玩家数量；
广告新增玩家数：当天注册的非自然新增(视为广告新增)玩家数量;
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300086)
- dataset SQL: `mysql://ba/data_set#300086`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:290