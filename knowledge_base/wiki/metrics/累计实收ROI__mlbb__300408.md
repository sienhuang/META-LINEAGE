# 累计实收ROI · mlbb  `累计实收ROI__mlbb__300408`

> 逻辑指标 [[累计实收ROI]] 在产品线 **mlbb** 的实例

- **公式**: `sum(total_actual_amt)/sum(consume_amt)`
- **业务口径**: 累计实收ROI
- 宽表: mt_ads_realtime.realtime_basic_online  (dataset 300408)
- dataset SQL: `mysql://ba/data_set#300408`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/PublishCnTargetMonitor/const.ts:117