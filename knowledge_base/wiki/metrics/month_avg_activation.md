# 月均活跃度  `month_avg_activation`

**业务口径**: 月度指标不受日期筛选器控制；自然月粒度下，月均DAU/MAU = (sum(月每日活跃玩家数)/月总天数) / 月去重活跃玩家数

## 怎么算
**公式**: `sum(indicator_map['avg_active_cnt']) / cast(sum(indicator_map['mau']) as decimal(38,0))`

依赖的底层指标:
- [[avg_active_cnt]] (日均活跃) — `[示例] sum(active_cnt) / count(distinct logymd)` [草稿] · 取数 `indicator_map['avg_active_cnt']`
- [[mau]] (月活跃用户数(去重)) — `[示例] count(distinct uid)  -- 自然月内去重` [草稿] · 取数 `indicator_map['mau']`

## 数据来源
- 宽表: [[dws_mlbb_indicator_wide_1d]]
- dataset: 300016  · 产品线 scope: ['mlbb']

## 元信息
- 分类: core-dau · tier: 头部