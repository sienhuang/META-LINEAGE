# 月均扑脸CTR · mlbb  `月均扑脸CTR__mlbb`

> 逻辑指标 [[月均扑脸CTR]] 在产品线 **mlbb** 的实例

- **公式**: `cast(sum(indicator_map['click_pv']) as decimal(38,0))/cast(sum(indicator_map['exposure_pv']) as decimal(38,0))`
- **业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，(月扑脸点击总pv) / (月扑脸点击曝光总pv)
- 宽表: mt_ads_pre.ads_gamebi_roger_secondary_di  (dataset 300016)
- dataset SQL: `mysql://ba/data_set#300016`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:150