# MLBB月均下载量(ST)  `MLBB月均下载量(ST)`

**业务口径**: ST上获取到的MLBB的下载量

## 怎么算
**公式**: `st_downloads`

依赖的底层指标:
- [[st_downloads]] (?) — `⚠️待D层` [待补] · 取数 `st_downloads`

## 数据来源
- 宽表: [[ads_gamebi_competitor_gamemarket_mi]]
- dataset: ['300064']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **st_downloads** @ `test.ads_gamebi_competitor_gamemarket_mi`
  - 口径指针: `etl://test.ads_gamebi_competitor_gamemarket_mi:st_downloads`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾