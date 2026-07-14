# 段位  `big_ranklevel`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(match_exp_matchid_socre_array)/sum(match_exp_match_num_array)`

依赖的底层指标:
- [[match_exp_match_num]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_match_num`
- [[match_exp_match_num_array]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_match_num_array`
- [[match_exp_matchid_socre]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_matchid_socre`
- [[match_exp_matchid_socre_array]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_matchid_socre_array`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:1205