# 登录转化率  `login`

**业务口径**: （进入主城看到主界面角色数）/（点击MLBB图标角色数）*100%；数据可计算最早时间为 2024-09-19

## 怎么算
**公式**: `sum(indicator_map['login_sucess_cnt'])/cast(sum(indicator_map['login_auth_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[login_auth_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['login_auth_cnt']`
- [[login_sucess_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['login_sucess_cnt']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1408