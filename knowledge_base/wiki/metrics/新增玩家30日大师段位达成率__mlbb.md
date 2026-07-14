# 新增玩家30日大师段位达成率 · mlbb  `新增玩家30日大师段位达成率__mlbb`

> 逻辑指标 [[新增玩家30日大师段位达成率]] 在产品线 **mlbb** 的实例

- **公式**: `sum(indicator_map['ranklevel_master_cnt'])/cast(sum(indicator_map['pure_register_cnt']) as decimal(38,0))`
- **业务口径**: 新增玩家30日[大师/宗师]段位达成率:(纯净新增玩家注册后30日内[大师/宗师]及以上段位达成玩家)/(当日新增注册玩家数)*100%
数据更新周期为T+29
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1508