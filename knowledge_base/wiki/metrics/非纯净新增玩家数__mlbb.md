# 非纯净新增玩家数 · mlbb  `非纯净新增玩家数__mlbb`

> 逻辑指标 [[非纯净新增玩家数]] 在产品线 **mlbb** 的实例

- **公式**: `sum(register_cnt)-sum(pure_register_cnt)`
- **业务口径**: 纯净新增玩家数：注册日期为当天的纯净新增的玩家数量；
非纯净新增玩家数：注册日期排除纯净新增玩家后剩余的所有新增玩家数;
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300086)
- dataset SQL: `mysql://ba/data_set#300086`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/UserOverview/Component/SecondaryIndicators/const.ts:242