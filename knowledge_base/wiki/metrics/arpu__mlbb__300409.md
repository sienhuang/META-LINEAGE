# arpu · mlbb  `arpu__mlbb__300409`

> 逻辑指标 [[arpu]] 在产品线 **mlbb** 的实例

- **公式**: `avg(pay_amt)/100/avg(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_charge  (dataset 300409)
- dataset SQL: `mysql://ba/data_set#300409`
- 维度: ['channel']  · 过滤: ['<dynamic>']
- 来源代码: src/views/PublishCnTargetMonitor/Component/CascaderTable/const.ts:379