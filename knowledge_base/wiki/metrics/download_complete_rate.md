# 增量下载完成率  `download_complete_rate`

**业务口径**: (T日增量下载完成角色数 + T日增量下载未完成但 [T+1: T+2] 首次登录时增量下载完成的角色数）/ (T日登录总角色数) * 100%

## 怎么算
**公式**: `sum(indicator_map['download_complete_cnt'])/cast(sum(indicator_map['download_login_cnt']) as decimal(38,0))`

依赖的底层指标:
- [[download_complete_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['download_complete_cnt']`
- [[download_login_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['download_login_cnt']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:1288