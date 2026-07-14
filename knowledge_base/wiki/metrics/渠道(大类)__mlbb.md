# 渠道(大类) · mlbb  `渠道(大类)__mlbb`

> 逻辑指标 [[渠道(大类)]] 在产品线 **mlbb** 的实例

- **公式**: `avg(pay_amt)/100/avg(active_cnt)`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300410)
- dataset SQL: `mysql://ba/data_set#300410`
- 维度: ['channel', 'logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/PublishCnTargetMonitor/Component/CascaderTable/const.ts:861