# finish_rate · mlbb  `finish_rate__mlbb`

> 逻辑指标 [[finish_rate]] 在产品线 **mlbb** 的实例

- **公式**: `(avg(pay_amt)*avg(active_cnt_kpi))/(avg(active_cnt)*avg(pay_amt_kpi))*100`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_charge  (dataset 300409)
- dataset SQL: `mysql://ba/data_set#300409`
- 维度: ['channel']  · 过滤: ['<dynamic>']
- 来源代码: src/views/PublishCnTargetMonitor/Component/CascaderTable/const.ts:379