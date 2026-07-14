# 社会属性标签  `sex`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_black_cnt_sex)/sum(day_battle_cnt_sex)`

依赖的底层指标:
- [[day_battle_cnt_sex]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_sex`
- [[day_black_cnt_sex]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_sex`
- [[day_black_cnt_sex_total]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_sex_total`
- [[ol_dur_sex_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_arr`
- [[ol_dur_sex_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_role_cnt_arr`
- [[ol_dur_sex_role_cnt_arr_total]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_role_cnt_arr_total`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:784