# PCU & ACU  `online`

**业务口径**: PCU: 最大同时在线玩家数
ACU: 平均同时在线玩家数

## 怎么算
**公式**: `online_num`

依赖的底层指标:
- [[acu]] (?) — `⚠️待D层` [待补] · 取数 `acu`
- [[online_num]] (?) — `⚠️待D层` [待补] · 取数 `online_num`
- [[pcu]] (?) — `⚠️待D层` [待补] · 取数 `pcu`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200013', '300004', '300008', '300040', '300041', '300148', '300151', '300162', '300174', '300175', '300188', '300200', '300229', '300235', '300280', '300287', '300371'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mcgg', 'mla', 'mlbb', 'mlcn', 'nova_cn', 'wefly_cn', 'zgame', 'zgame_cn'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:192