# login_auth_cnt  `login_auth_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(login_auth_cnt)`

依赖的底层指标:
- [[login_auth_cnt]] (?) — `⚠️待D层` [待补] · 取数 `login_auth_cnt`

## 数据来源
- 宽表: [[ads_decismart_performance_cube_di]]
- dataset: ['300099']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **login_auth_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:login_auth_cnt`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾