# 月日均DAU  `月日均DAU`

**业务口径**: 月度指标不受日期筛选器控制; 自然月粒度下，月均活跃度=月日均DAU / MAU=(sum(月每日活跃玩家数) / 月总天数) / (月去重活跃玩家数)

## 怎么算
**公式**: `sum(indicator_map['avg_active_cnt'])`

依赖的底层指标:
- [[avg_active_cnt]] (日均活跃) — `[示例] sum(active_cnt) / count(distinct logymd)` [草稿] · 取数 `indicator_map['avg_active_cnt']`

## 数据来源
- 宽表: [[ads_gamebi_roger_secondary_di]], [[realtime_recurring]]
- dataset: ['300202', '300256', '300363']  · 产品线 scope: ['wefly_cn', 'wegame', 'zgame_cn']

## 各产品线实例
- [[月日均DAU__wefly_cn__300202]] (scope=wefly_cn, dataset=300202, 宽表=mt_ads.ads_gamebi_roger_secondary_di)
- [[月日均DAU__wegame__300256]] (scope=wegame, dataset=300256, 宽表=mt_ads.ads_gamebi_roger_secondary_di)
- [[月日均DAU__zgame_cn__300363]] (scope=zgame_cn, dataset=300363, 宽表=mt_ads_realtime.realtime_recurring)

## 元信息
- 分类: core-dau · tier: 长尾