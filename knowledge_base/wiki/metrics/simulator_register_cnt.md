# 新增类型  `simulator_register_cnt`

**业务口径**: 纯净新增：当日新注册且排除回流切号、模拟器和灰产后的去重玩家数
切号新增：当日新注册且存在切换新老账号的去重玩家数
模拟器新增：当日新注册且判定为模拟器设备的去重玩家数
灰产新增：当日新注册且判定为灰产的去重玩家数

## 怎么算
**公式**: `sum(gray_register_cnt)`

依赖的底层指标:
- [[gray_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `gray_register_cnt`
- [[pure_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pure_register_cnt`
- [[simulator_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `simulator_register_cnt`
- [[switch_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `switch_register_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300197'])
- 维度: —  · 过滤: —

## 元信息
- 分类: register · 产品线: ['mcgg'] · tier: 长尾
- 来源代码: src/views/MCGGOverview/Component/SecondaryIndicators/const.ts:217