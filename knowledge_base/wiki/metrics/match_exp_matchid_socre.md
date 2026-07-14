# 匹配体验平均分  `match_exp_matchid_socre`

**业务口径**: 因AIAD业务迁移，匹配体验平均分指标有效日期从2024-02-29开始

## 怎么算
**公式**: `sum(match_exp_matchid_socre_array)/sum(match_exp_match_num_array)`

依赖的底层指标:
- [[match_exp_match_num_array]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_match_num_array`
- [[match_exp_matchid_socre_array]] (?) — `⚠️待D层` [待补] · 取数 `match_exp_matchid_socre_array`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300130'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/const.ts:246