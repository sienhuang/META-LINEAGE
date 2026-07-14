# step1  `step1`

**业务口径**: 增量检测耗时

## 怎么算
**公式**: `sum(checking_step_1/1000)`

依赖的底层指标:
- [[checking_step_1]] (?) — `⚠️待D层` [待补] · 取数 `checking_step_1`

## 数据来源
- 宽表: [[ads_decismart_performance_cube_di]]
- dataset: ['300099']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **checking_step_1** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:checking_step_1`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾