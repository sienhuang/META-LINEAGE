# value_7  `value_7`

**业务口径**: ⚠️ 缺人话口径(待补)

## 怎么算
**公式**: `sum(pure_reten_day7)/sum(pure_reten_day7_total)`

依赖的底层指标:
- [[pure_reten_day7]] (?) — `⚠️待D层` [待补] · 取数 `pure_reten_day7`
- [[pure_reten_day7_total]] (?) — `⚠️待D层` [待补] · 取数 `pure_reten_day7_total`
- [[register_reten_cnt_7]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_7`
- [[register_reten_cnt_7_total]] (?) — `⚠️待D层` [待补] · 取数 `register_reten_cnt_7_total`
- [[register_cnt_7d]] (?) — `⚠️待D层` [待补] · 取数 `register_cnt_7d`
- [[register_reten7]] (?) — `⚠️待D层` [待补] · 取数 `register_reten7`
- [[create_role_day_cnt_7d]] (?) — `⚠️待D层` [待补] · 取数 `create_role_day_cnt_7d`
- [[login_day_cnt_7d]] (?) — `⚠️待D层` [待补] · 取数 `login_day_cnt_7d`
- [[mp_product_money]] (?) — `⚠️待D层` [待补] · 取数 `mp_product_money`
- [[product_money]] (?) — `product_money` [已确认] · 取数 `product_money`

## 数据来源
- 宽表: [[ads_gamebi_roger_primary_di]], [[ads_gamebi_roger_primary_di_us]], [[ads_decismart_reten_ltv_df]], [[realtime_basic_login]], [[dm_finance_role_zone_tz_di]], [[realtime_basic_create_role_retention]], [[realtime_create_role_retention]], [[realtime_create_role_retention]]
- dataset: ['300196', '300369', '300270', '300402', '300365', '300423', '300172', '300420', '300411', '300169', '300182', '300179', '300249', '300234', '300311']  · 产品线 scope: ['mlbb', 'lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5']

## 字段生成逻辑(D 层)
- **pure_reten_day7** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_roger_primary_di:pure_reten_day7`(D 层未自动解析,待补)
- **pure_reten_day7_total** @ `mt_ads.ads_gamebi_roger_primary_di`
  - 口径指针: `etl://mt_ads.ads_gamebi_roger_primary_di:pure_reten_day7_total`(D 层未自动解析,待补)
- **register_reten_cnt_7** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_7`(D 层未自动解析,待补)
- **register_reten_cnt_7_total** @ `mt_ads.ads_decismart_reten_ltv_df`
  - 口径指针: `etl://mt_ads.ads_decismart_reten_ltv_df:register_reten_cnt_7_total`(D 层未自动解析,待补)
- **register_cnt_7d** @ `mt_ads_realtime.ads_mlbb_realtime_batch_data_di`
  - 口径指针: `etl://mt_ads_realtime.ads_mlbb_realtime_batch_data_di:register_cnt_7d`(D 层未自动解析,待补)
- **register_reten7** @ `mt_ads_realtime.ads_mlbb_realtime_batch_data_di`
  - 口径指针: `etl://mt_ads_realtime.ads_mlbb_realtime_batch_data_di:register_reten7`(D 层未自动解析,待补)
- **create_role_day_cnt_7d** @ `mt_ads_realtime.realtime_basic_create_role_retention`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_create_role_retention:create_role_day_cnt_7d`(D 层未自动解析,待补)
- **login_day_cnt_7d** @ `mt_ads_realtime.realtime_basic_create_role_retention`
  - 口径指针: `etl://mt_ads_realtime.realtime_basic_create_role_retention:login_day_cnt_7d`(D 层未自动解析,待补)
- **mp_product_money** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_role_zone_tz_di:mp_product_money`(D 层未自动解析,待补)
- **product_money** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.product_money`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041175_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041367_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041902_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041174_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100041176_1:t_charge.product_money` [direct] `product_money`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.product_money` ⇐ `cte:job.100042046_1:t_charge.product_money` [direct] `product_money`
    - d1 `cte:job.100041175_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041367_1:t_charge.product_money` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041902_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041174_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100041176_1:t_charge.product_money` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d1 `cte:job.100042046_1:t_charge.product_money` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` [aggregated] `SUM(product_money) AS product_money /* 定价流水 */`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041772_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041891_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100042035_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100042024_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041772_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041891_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041772_0:t2.product_money` [direct] `product_money`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.product_money` ⇐ `subquery:job.100041891_0:t2.product_money` [direct] `product_money`

## 各产品线实例
- [[value_7__aoz__300423]] (scope=aoz, dataset=300423, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__aoz__300172]] (scope=aoz, dataset=300172, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__aoz__300420]] (scope=aoz, dataset=300420, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[value_7__aoz__300411]] (scope=aoz, dataset=300411, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[value_7__lovania_cn__300369]] (scope=lovania_cn, dataset=300369, 宽表=mt_ads.ads_gamebi_roger_primary_di_us)
- [[value_7__lovania_cn__300270]] (scope=lovania_cn, dataset=300270, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__lovania_cn__300402]] (scope=lovania_cn, dataset=300402, 宽表=mt_ads_realtime.realtime_basic_login)
- [[value_7__lovania_cn__300365]] (scope=lovania_cn, dataset=300365, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[value_7__mlbb__300196]] (scope=mlbb, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[value_7__mlbb__300172]] (scope=mlbb, dataset=300172, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__mlbb__300169]] (scope=mlbb, dataset=300169, 宽表=mt_ads_realtime_pre.realtime_create_role_retention)
- [[value_7__mlbb__300182]] (scope=mlbb, dataset=300182, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__mlbb__300179]] (scope=mlbb, dataset=300179, 宽表=mt_ads_realtime.realtime_create_role_retention)
- [[value_7__mlbb__300249]] (scope=mlbb, dataset=300249, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__mlbb__300234]] (scope=mlbb, dataset=300234, 宽表=mt_ads_realtime.realtime_create_role_retention)
- [[value_7__mlbb__300311]] (scope=mlbb, dataset=300311, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[value_7__sgame_cn__300369]] (scope=sgame_cn, dataset=300369, 宽表=mt_ads.ads_gamebi_roger_primary_di_us)
- [[value_7__sgame_cn__300270]] (scope=sgame_cn, dataset=300270, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__sgame_cn__300402]] (scope=sgame_cn, dataset=300402, 宽表=mt_ads_realtime.realtime_basic_login)
- [[value_7__sgame_cn__300365]] (scope=sgame_cn, dataset=300365, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[value_7__tgame__300423]] (scope=tgame, dataset=300423, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__tgame__300172]] (scope=tgame, dataset=300172, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__tgame__300420]] (scope=tgame, dataset=300420, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[value_7__tgame__300411]] (scope=tgame, dataset=300411, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[value_7__wefly5__300423]] (scope=wefly5, dataset=300423, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__wefly5__300172]] (scope=wefly5, dataset=300172, 宽表=mt_ads.ads_decismart_reten_ltv_df)
- [[value_7__wefly5__300420]] (scope=wefly5, dataset=300420, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)
- [[value_7__wefly5__300411]] (scope=wefly5, dataset=300411, 宽表=mt_ads_realtime.realtime_basic_create_role_retention)

## 元信息
- 分类: retention · tier: 长尾