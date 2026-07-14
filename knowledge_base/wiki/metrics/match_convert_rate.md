# 匹配转化率  `match_convert_rate`

**业务口径**: 分母：在match服务器上匹配成功的所有玩家人次
分子：匹配成功后客户端成功弹出提示框的玩家人次

## 怎么算
**公式**: `sum(match_trace_cnt)/sum(match_suc_cnt)`

依赖的底层指标:
- [[match_suc_cnt]] (?) — `⚠️待D层` [待补] · 取数 `match_suc_cnt`
- [[match_trace_cnt]] (?) — `⚠️待D层` [待补] · 取数 `match_trace_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300099'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/SecondaryIndicators/const.ts:280