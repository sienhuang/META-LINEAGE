# user_download_login_cnt  `user_download_login_cnt`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(user_download_login_cnt)`

依赖的底层指标:
- [[user_download_login_cnt]] (?) — `⚠️待D层` [待补] · 取数 `user_download_login_cnt`

## 数据来源
- 宽表: [[ads_decismart_performance_cube_di]], [[ads_decismart_performance_cube_di]]
- dataset: ['300099', '300104']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **user_download_login_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:user_download_login_cnt`(D 层未自动解析,待补)

## 各产品线实例
- [[user_download_login_cnt__mlbb__300099]] (scope=mlbb, dataset=300099, 宽表=mt_ads.ads_decismart_performance_cube_di)
- [[user_download_login_cnt__mlbb__300104]] (scope=mlbb, dataset=300104, 宽表=test.ads_decismart_performance_cube_di)

## 元信息
- 分类: other · tier: 长尾