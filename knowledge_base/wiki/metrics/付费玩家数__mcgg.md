# 付费玩家数 · mcgg  `付费玩家数__mcgg`

> 逻辑指标 [[付费玩家数]] 在产品线 **mcgg** 的实例

- **公式**: `sum(pay_cnt)`
- **业务口径**: 当日去重付费玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300197)
- dataset SQL: `mysql://ba/data_set#300197`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:364