# 昨日新增次留  `new_login_cnt_percent`

**业务口径**: (T-1日新增、且T日登录的去重玩家数) / (T-1新增的去重玩家数) * 100%

## 怎么算
**公式**: `sum(login_day_cnt)/sum(create_role_day_cnt)`

依赖的底层指标:
- [[create_role_day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `create_role_day_cnt`
- [[create_role_point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `create_role_point_cnt`
- [[login_day_cnt]] (?) — `⚠️待D层` [待补] · 取数 `login_day_cnt`
- [[login_point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `login_point_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['200000', '200001'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlcn'] · tier: 长尾
- 来源代码: src/views/MlcnRealTime/const.ts:275