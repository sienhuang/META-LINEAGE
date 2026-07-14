# MLBB月均收入(ST)  `MLBB月均收入(ST)`

**业务口径**: ST上获取到的MLBB的流水

## 怎么算
**公式**: `st_income`

依赖的底层指标:
- [[st_income]] (?) — `⚠️待D层` [待补] · 取数 `st_income`

## 数据来源
- 宽表: [[ads_gamebi_competitor_gamemarket_mi]]
- dataset: ['300064']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **st_income** @ `test.ads_gamebi_competitor_gamemarket_mi`
  - 口径指针: `etl://test.ads_gamebi_competitor_gamemarket_mi:st_income`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾