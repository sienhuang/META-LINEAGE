# pay_amt · zgame_cn  `pay_amt__zgame_cn`

> 逻辑指标 [[pay_amt]] 在产品线 **zgame_cn** 的实例

- **公式**: `metric_cal(pay_amt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.ads_realtime_batch_data_di  (dataset 300300)
- dataset SQL: `mysql://ba/data_set#300300`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/ZgameCnRealTime/Component/CascaderTable/const.ts:314