# PCU · wegame  `PCU__wegame__300260`

> 逻辑指标 [[PCU]] 在产品线 **wegame** 的实例

- **公式**: `pcu`
- **业务口径**: PCU: 最大同时在线玩家数
ACU: 平均同时在线玩家数
当全局筛选选择广告/登录渠道，选择多个国家，或剔除刷号选择“是”时该看板数据不做展示
- 宽表: mt_ads.ads_decismart_online_di  (dataset 300260)
- dataset SQL: `mysql://ba/data_set#300260`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/WeflyOverview/Component/SecondaryIndicators/const.ts:299