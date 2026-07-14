# 月均扑脸CTR  `month_avg_ctr`

**业务口径**: 月度指标不受日期筛选器控制;
自然月粒度下，(月扑脸点击总pv) / (月扑脸点击曝光总pv)

## 怎么算
**公式**: `cast(sum(indicator_map['click_pv']) as decimal(38,0))/cast(sum(indicator_map['exposure_pv']) as decimal(38,0))`

依赖的底层指标:
- [[click_pv]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['click_pv']`
- [[exposure_pv]] (?) — `⚠️待D层` [待补] · 取数 `indicator_map['exposure_pv']`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300016'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/BusinessOverview/Component/SecondaryIndicators/const.ts:150