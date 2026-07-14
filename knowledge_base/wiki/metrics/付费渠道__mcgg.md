# 付费渠道 · mcgg  `付费渠道__mcgg`

> 逻辑指标 [[付费渠道]] 在产品线 **mcgg** 的实例

- **公式**: `pay_amt/100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads.ads_decismart_pay_channel_di  (dataset 300221)
- dataset SQL: `mysql://ba/data_set#300221`
- 维度: ['pay_channel', 'logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/CascaderTable/const.ts:1112