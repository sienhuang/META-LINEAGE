# 新增留存  `new_retention`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(login_day_cnt_7d)/sum(create_role_day_cnt_7d)`

依赖的底层指标:
- [[create_role_day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `create_role_day_cnt`
- [[create_role_day_cnt_7d]] (?) — `⚠️待D层` [待补] · 取数 `create_role_day_cnt_7d`
- [[login_day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `login_day_cnt`
- [[login_day_cnt_7d]] (?) — `⚠️待D层` [待补] · 取数 `login_day_cnt_7d`
- [[register_reten_cnt_2]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_2`
- [[register_reten_cnt_2_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_2_total`
- [[register_reten_cnt_30]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_30`
- [[register_reten_cnt_30_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_30_total`
- [[register_reten_cnt_7]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_7`
- [[register_reten_cnt_7_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_7_total`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200000', '200001', '300058', '300168', '300169', '300172', '300178', '300179', '300182', '300194', '300196', '300213', '300214', '300216', '300228', '300234', '300249'])
- 维度: —  · 过滤: —

## 元信息
- 分类: retention · 产品线: ['default', 'mla', 'mlbb', 'mlcn', 'nova_cn', 'wefly_cn', 'zgame', 'zgame_cn'] · tier: 长尾
- 来源代码: src/views/CompetitiveOverview/const.ts:261