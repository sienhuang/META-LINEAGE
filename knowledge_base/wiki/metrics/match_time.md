# 匹配时长  `match_time`

**业务口径**: sum(每场战斗匹配时长) / 总匹配战局数

## 怎么算
**公式**: `SUM(indicator_map['match_success_time_39'] + indicator_map['match_success_time_201'] + indicator_map['match_success_time_301'] + indicator_map['match_success_time_170']) / cast(SUM(indicator_map['match_success_cnt_39'] + indicator_map['match_success_cnt_201'] + indicator_map['match_success_cnt_301'] + indicator_map['match_success_cnt_170']) as decimal(38,0))`

依赖的底层指标:
- [[battlecnt_match_time_fm]] (?) — `⚠️待D层` [待补] · 取数 `battlecnt_match_time_fm`
- [[match_success_cnt_170]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_170']`
- [[match_success_cnt_201]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_201']`
- [[match_success_cnt_301]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_301']`
- [[match_success_cnt_39]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_39']`
- [[match_success_time_170]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_time_170']`
- [[match_success_time_201]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_time_201']`
- [[match_success_time_301]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_time_301']`
- [[match_success_time_39]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_time_39']`
- [[totalmatchtime_match_time_fm]] (?) — `⚠️待D层` [待补] · 取数 `totalmatchtime_match_time_fm`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016', '300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mcgg', 'mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:962