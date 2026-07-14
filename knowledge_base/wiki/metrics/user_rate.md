# user_rate  `user_rate`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(ol_dur_user_type_role_cnt_arr)/sum(ol_dur_user_type_role_cnt_arr_total) * 100`

依赖的底层指标:
- [[ol_dur_user_type_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_user_type_role_cnt_arr`
- [[ol_dur_user_type_role_cnt_arr_total]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_user_type_role_cnt_arr_total`
- [[ol_dur_age_group_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_role_cnt_arr`
- [[ol_dur_age_group_role_cnt_arr_total]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_age_group_role_cnt_arr_total`
- [[ol_dur_sex_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_role_cnt_arr`
- [[ol_dur_sex_role_cnt_arr_total]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_sex_role_cnt_arr_total`
- [[user_download_login_cnt]] (?) — `⚠️待D层` [待补] · 取数 `user_download_login_cnt`
- [[user_download_login_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `user_download_login_cnt_total`

## 数据来源
- 宽表: [[ads_decismart_rank_analysis]], [[ads_decismart_performance_cube_di]]
- dataset: ['300118', '300120', '300122', '300104']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **ol_dur_user_type_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_user_type_role_cnt_arr`(D 层未自动解析,待补)
- **ol_dur_user_type_role_cnt_arr_total** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_user_type_role_cnt_arr_total`(D 层未自动解析,待补)
- **ol_dur_age_group_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_age_group_role_cnt_arr`(D 层未自动解析,待补)
- **ol_dur_age_group_role_cnt_arr_total** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_age_group_role_cnt_arr_total`(D 层未自动解析,待补)
- **ol_dur_sex_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_sex_role_cnt_arr`(D 层未自动解析,待补)
- **ol_dur_sex_role_cnt_arr_total** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_sex_role_cnt_arr_total`(D 层未自动解析,待补)
- **user_download_login_cnt** @ `mt_ads.ads_decismart_performance_cube_di`
  - 口径指针: `etl://mt_ads.ads_decismart_performance_cube_di:user_download_login_cnt`(D 层未自动解析,待补)
- **user_download_login_cnt_total** @ `test.ads_decismart_performance_cube_di`
  - 口径指针: `etl://test.ads_decismart_performance_cube_di:user_download_login_cnt_total`(D 层未自动解析,待补)

## 各产品线实例
- [[user_rate__mlbb__300118]] (scope=mlbb, dataset=300118, 宽表=test.ads_decismart_rank_analysis)
- [[user_rate__mlbb__300120]] (scope=mlbb, dataset=300120, 宽表=test.ads_decismart_rank_analysis)
- [[user_rate__mlbb__300122]] (scope=mlbb, dataset=300122, 宽表=test.ads_decismart_rank_analysis)
- [[user_rate__mlbb__300104]] (scope=mlbb, dataset=300104, 宽表=test.ads_decismart_performance_cube_di)

## 元信息
- 分类: other · tier: 长尾