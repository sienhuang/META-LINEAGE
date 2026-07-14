# 月度2美金付费率  `2usd_pay_cnt`

**业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，(当月累计付费达2美金的玩家数) / (月均DAU) * 100%

## 怎么算
**公式**: `sum(pay_cnt_month)/sum(active_cnt)`

依赖的底层指标:
- [[2usd_pay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['2usd_pay_cnt']`
- [[active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `active_cnt`
- [[avg_active_cnt]] (日均活跃) — `[示例] sum(active_cnt) / count(distinct logymd)` [草稿] · 取数 `indicator_map['avg_active_cnt']`
- [[pay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `pay_cnt`
- [[pay_cnt_month]] (?) — `⚠️待D层` [待补] · 取数 `pay_cnt_month`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016', '300254'])
- 维度: —  · 过滤: —

## 元信息
- 分类: core-dau · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:511