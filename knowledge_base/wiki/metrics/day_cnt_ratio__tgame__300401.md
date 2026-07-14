# day_cnt_ratio · tgame  `day_cnt_ratio__tgame__300401`

> 逻辑指标 [[day_cnt_ratio]] 在产品线 **tgame** 的实例

- **公式**: `sum(day_cnt) / SUM(sum(day_cnt)) OVER ()`
- **业务口径**: ⚠️ 缺(见逻辑指标)
- 宽表: mt_ads_realtime.realtime_basic_login  (dataset 300401)
- dataset SQL: `mysql://ba/data_set#300401`
- 维度: ['channel']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/CommonOverseaRealTime/Component/CascaderTable/const.ts:97