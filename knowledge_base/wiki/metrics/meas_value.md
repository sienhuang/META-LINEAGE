# 模块  `meas_value`

**业务口径**: 每个赛季版本问卷中，对于战场现状表示满意的人群占比；长周期筛选下展示最近一次得分；由于指标计算为黑盒，无法按区域聚合，数据将不受区域筛选器影响，但受国家筛选器影响

## 怎么算
**公式**: `meas_value`

依赖的底层指标:
- [[meas_value]] (?) — `⚠️待D层` [待补] · 取数 `meas_value`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset ['300112', '300113'])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/GameExperienceOverview/Component/CascaderTable/const.ts:511