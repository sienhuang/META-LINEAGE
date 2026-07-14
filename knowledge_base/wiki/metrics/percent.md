# percent  `percent`

**业务口径**: 新增玩家引导 & 场次漏斗：新增首日达成各场次分层的玩家人数；
数据起始日期为2022-05-29；
由于埋点缺失，新增玩家引导转化漏斗在2024.1.31 ~ 2024.3.13  及  2024.6.25 ~ 2024.8.18 期间数据为空。

## 怎么算
**公式**: `sum(new_user_battle_cnt)/sum(new_user_battle_cnt_pre)*100`

依赖的底层指标:
- [[new_user_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `new_user_battle_cnt`
- [[new_user_battle_cnt_pre]] (?) — `⚠️待D层` [待补] · 取数 `new_user_battle_cnt_pre`
- [[recall_user_battle_cnt]] (?) — `⚠️待D层` [待补] · 取数 `recall_user_battle_cnt`
- [[recall_user_battle_cnt_pre]] (?) — `⚠️待D层` [待补] · 取数 `recall_user_battle_cnt_pre`

## 数据来源
- 宽表: [[ads_decismart_new_recall_battle_funnel]]
- dataset: ['300126', '300128']  · 产品线 scope: ['mlbb']

## 字段生成逻辑(D 层)
- **new_user_battle_cnt** @ `test.ads_decismart_new_recall_battle_funnel`
  - 口径指针: `etl://test.ads_decismart_new_recall_battle_funnel:new_user_battle_cnt`(D 层未自动解析,待补)
- **new_user_battle_cnt_pre** @ `test.ads_decismart_new_recall_battle_funnel`
  - 口径指针: `etl://test.ads_decismart_new_recall_battle_funnel:new_user_battle_cnt_pre`(D 层未自动解析,待补)
- **recall_user_battle_cnt** @ `test.ads_decismart_new_recall_battle_funnel`
  - 口径指针: `etl://test.ads_decismart_new_recall_battle_funnel:recall_user_battle_cnt`(D 层未自动解析,待补)
- **recall_user_battle_cnt_pre** @ `test.ads_decismart_new_recall_battle_funnel`
  - 口径指针: `etl://test.ads_decismart_new_recall_battle_funnel:recall_user_battle_cnt_pre`(D 层未自动解析,待补)

## 各产品线实例
- [[percent__mlbb__300126]] (scope=mlbb, dataset=300126, 宽表=test.ads_decismart_new_recall_battle_funnel)
- [[percent__mlbb__300128]] (scope=mlbb, dataset=300128, 宽表=test.ads_decismart_new_recall_battle_funnel)

## 元信息
- 分类: register · tier: 长尾