# st_mau  `st_mau`

**业务口径**: 「下载量top100」、「MAU top100」、「收入金额top100」游戏并集，总数可能超过100

## 怎么算
**公式**: `st_mau`

依赖的底层指标:
- [[st_mau]] (?) — `⚠️待D层` [待补] · 取数 `st_mau`

## 数据来源
- 宽表: [[ads_gamebi_competitor_gamemarket_mf]]
- dataset: ['300068']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **st_mau** @ `test.ads_gamebi_competitor_gamemarket_mi`
  - 口径指针: `etl://test.ads_gamebi_competitor_gamemarket_mi:st_mau`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾