# 渠道 · aoz  `渠道__aoz`

> 逻辑指标 [[渠道]] 在产品线 **aoz** 的实例

- **公式**: `sum(pay_amt)/100/sum(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300419)
- dataset SQL: `mysql://ba/data_set#300419`
- 维度: ['logymd', 'channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const_countries.ts:540