# 新老用户  `user_type`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(user_storage_download_complete_cnt)/sum(user_download_login_cnt)`

依赖的底层指标:
- [[user_download_login_cnt]] (?) — `⚠️待D层` [待补] · 取数 `user_download_login_cnt`
- [[user_download_login_cnt_total]] (?) — `⚠️待D层` [待补] · 取数 `user_download_login_cnt_total`
- [[user_storage_download_complete_cnt]] (?) — `⚠️待D层` [待补] · 取数 `user_storage_download_complete_cnt`

## 数据来源
- 宽表: ⚠️ 待P2  (dataset [])
- 维度: —  · 过滤: —

## 元信息
- 分类: other · 产品线: ['mlbb'] · tier: 长尾
- 来源代码: src/views/InfrastructureOverview/Component/CascaderTable/const.ts:399