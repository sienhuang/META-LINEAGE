# 对局时长  `day_battle_duration`

**业务口径**: 各个段位对局的平均时长  单位为分钟

## 怎么算
**公式**: `sum(day_battle_dur_fz_7)/sum(day_battle_dur_cnt_fm_7)/60`

依赖的底层指标:
- [[day_battle_dur_cnt_fm]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm`
- [[day_battle_dur_cnt_fm_0]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_0`
- [[day_battle_dur_cnt_fm_1]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_1`
- [[day_battle_dur_cnt_fm_2]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_2`
- [[day_battle_dur_cnt_fm_3]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_3`
- [[day_battle_dur_cnt_fm_4]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_4`
- [[day_battle_dur_cnt_fm_5]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_5`
- [[day_battle_dur_cnt_fm_6]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_6`
- [[day_battle_dur_cnt_fm_7]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_cnt_fm_7`
- [[day_battle_dur_fz]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz`
- [[day_battle_dur_fz_0]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_0`
- [[day_battle_dur_fz_1]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_1`
- [[day_battle_dur_fz_2]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_2`
- [[day_battle_dur_fz_3]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_3`
- [[day_battle_dur_fz_4]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_4`
- [[day_battle_dur_fz_5]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_5`
- [[day_battle_dur_fz_6]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_6`
- [[day_battle_dur_fz_7]] (?) — `⚠️待D层` [待补] · 取数 `day_battle_dur_fz_7`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300143'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/SecondaryIndicators/const.ts:28