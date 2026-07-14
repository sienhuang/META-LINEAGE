# day_amt · tgame  `day_amt__tgame__300405`

> 逻辑指标 [[day_amt]] 在产品线 **tgame** 的实例

- **公式**: `day_amt * 0.01`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_charge  (dataset 300405)
- dataset SQL: `mysql://ba/data_set#300405`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const.ts:437