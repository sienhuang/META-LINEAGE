# 社会属性标签  `age_group`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(day_black_cnt_age)/sum(day_battle_cnt_age)`

依赖的底层指标:
- [[day_battle_cnt_age]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_cnt_age`
- [[day_black_cnt_age]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_age`
- [[day_black_cnt_age_total]] (?) — `⚠️待D层` [待补] · 取数 `day_black_cnt_age_total`
- [[ol_dur_age_group_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_arr`
- [[ol_dur_age_group_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_role_cnt_arr`
- [[ol_dur_age_group_role_cnt_arr_total]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_role_cnt_arr_total`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:709