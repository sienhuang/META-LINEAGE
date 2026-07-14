# 机型  `model_type`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(carden_caton_cnt)/sum(carden_battle_cnt)`

依赖的底层指标:
- [[carden_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_battle_cnt']`
- [[carden_battle_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `carden_battle_cnt_total`
- [[carden_caton_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['carden_caton_cnt']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:105