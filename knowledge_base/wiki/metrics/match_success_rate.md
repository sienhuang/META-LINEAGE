# 匹配成功率  `match_success_rate`

**业务口径**: 今日匹配成功的战局 / 总匹配战局 * 100%；
数据起始日期为2023-12-20。

## 怎么算
**公式**: `SUM(indicator_map['match_success_cnt_39'] + indicator_map['match_success_cnt_201'] + indicator_map['match_success_cnt_301'] + indicator_map['match_success_cnt_170'] ) / cast(SUM(indicator_map['match_battle_cnt_39'] + indicator_map['match_battle_cnt_201'] + indicator_map['match_battle_cnt_301'] + indicator_map['match_battle_cnt_170']) as decimal(38,0))`

依赖的底层指标:
- [[battlecnt_match_time_fm]] (?) — `⚠️待D层` [待补] · 取数 `battlecnt_match_time_fm`
- [[match_battle_cnt_170]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_battle_cnt_170']`
- [[match_battle_cnt_201]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_battle_cnt_201']`
- [[match_battle_cnt_301]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_battle_cnt_301']`
- [[match_battle_cnt_39]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_battle_cnt_39']`
- [[match_success_cnt_170]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_170']`
- [[match_success_cnt_201]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_201']`
- [[match_success_cnt_301]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_301']`
- [[match_success_cnt_39]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['match_success_cnt_39']`
- [[successcnt_match_time_fm]] (?) — `⚠️待D层` [待补] · 取数 `successcnt_match_time_fm`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016', '300342'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mcgg', 'mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:915