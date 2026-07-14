# 区域 · aoz  `区域__aoz`

> 逻辑指标 [[区域]] 在产品线 **aoz** 的实例

- **公式**: `day_amt * 0.01`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_charge  (dataset 300405)
- dataset SQL: `mysql://ba/data_set#300405`
- 维度: ['country']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const_countries.ts:303