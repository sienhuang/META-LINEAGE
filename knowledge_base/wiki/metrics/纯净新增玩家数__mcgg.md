# 纯净新增玩家数 · mcgg  `纯净新增玩家数__mcgg`

> 逻辑指标 [[纯净新增玩家数]] 在产品线 **mcgg** 的实例

- **公式**: `sum(pure_register_cnt)`
- **业务口径**: 纯净新增：当日新注册且排除回流切号、模拟器和灰产后的去重玩家数
切号新增：当日新注册且存在切换新老账号的去重玩家数
模拟器新增：当日新注册且判定为模拟器设备的去重玩家数
灰产新增：当日新注册且判定为灰产的去重玩家数
- 宽表: mt_ads.ads_gamebi_roger_primary_di  (dataset 300197)
- dataset SQL: `mysql://ba/data_set#300197`
- 维度: ['logymd']  · 过滤: ['<dynamic>']
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:217