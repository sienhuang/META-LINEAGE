# 开黑类型  `black_battle_type`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_black_type_cnt)/sum(day_battle_cnt_total)`

依赖的底层指标:
- [[day_battle_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_total`
- [[day_black_type_cnt]] (?) — `⚠️待D层` [待补] · 取数 `day_black_type_cnt`
- [[day_black_type_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `day_black_type_cnt_total`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:930