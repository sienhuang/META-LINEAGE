# compet_day_login_duration_avg  `compet_day_login_duration_avg`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `compet_day_login_duration_avg`

依赖的底层指标:
- [[compet_day_login_duration_avg]] (?) — `⚠️待D层` [待补] · 取数 `compet_day_login_duration_avg`

## 数据来源
- 宽表: [[ads_gamebi_competitor_account_mi]]
- dataset: ['300069']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **compet_day_login_duration_avg** @ `test.ads_gamebi_competitor_account_mi`
  - 口径指针: `etl://test.ads_gamebi_competitor_account_mi:compet_day_login_duration_avg`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾