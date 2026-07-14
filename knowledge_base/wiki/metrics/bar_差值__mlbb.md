# bar_差值 · mlbb  `bar_差值__mlbb`

> 逻辑指标 [[bar_差值]] 在产品线 **mlbb** 的实例

- **公式**: `sum(add_diamond_amt-sub_diamond_amt)`
- **业务口径**: 钻石产出：当日系统产出的钻石数量，包含用户充值、GM发钻等，与金额类型无关；
钻石消耗：当日用户消耗的钻石数量，包含皮肤/英雄购买、星光、抽奖等，与金额类型无关；
- 宽表: mt_ads.ads_decismart_pay_cube_di  (dataset 300089)
- dataset SQL: `mysql://ba/data_set#300089`
- 维度: ['logymd']  · 过滤: ['logymd', 'appname', 'granularity_type', 'date_type', 'definition_type']
- 来源代码: src/views/IncomeOverview/Component/SecondaryIndicators/const.ts:331