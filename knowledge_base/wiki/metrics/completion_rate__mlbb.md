# completion_rate · mlbb  `completion_rate__mlbb`

> 逻辑指标 [[completion_rate]] 在产品线 **mlbb** 的实例

- **公式**: `sum(pay_amt_daily)/100/sum(active_cnt)/sum(arpu_kpi)`
- **业务口径**: 日均ARPU
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300406)
- dataset SQL: `mysql://ba/data_set#300406`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/PublishCnTargetMonitor/const.ts:400