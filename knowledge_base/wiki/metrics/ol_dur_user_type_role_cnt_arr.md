# ol_dur_user_type_role_cnt_arr  `ol_dur_user_type_role_cnt_arr`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(ol_dur_user_type_role_cnt_arr)`

依赖的底层指标:
- [[ol_dur_user_type_role_cnt_arr]] (?) — `⚠️待D层` [待补] · 取数 `ol_dur_user_type_role_cnt_arr`

## 数据来源
- 宽表: [[ads_decismart_rank_analysis]]
- dataset: ['300118']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **ol_dur_user_type_role_cnt_arr** @ `test.ads_decismart_rank_analysis`
  - 口径指针: `etl://test.ads_decismart_rank_analysis:ol_dur_user_type_role_cnt_arr`(D 层未自动解析,待补)

## 元信息
- 分类: other · tier: 长尾