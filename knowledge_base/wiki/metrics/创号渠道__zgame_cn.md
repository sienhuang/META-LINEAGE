# 创号渠道 · zgame_cn  `创号渠道__zgame_cn`

> 逻辑指标 [[创号渠道]] 在产品线 **zgame_cn** 的实例

- **公式**: `if(sum(active_cnt) = 0, 0, sum(pay_cnt)/sum(active_cnt))`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300304)
- dataset SQL: `mysql://ba/data_set#300304`
- 维度: ['<dynamic>']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/Component/CascaderTable/const_countries.ts:118