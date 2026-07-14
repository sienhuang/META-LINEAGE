# bar_value  `bar_value`

**业务口径**: 有登录行为的去重玩家数

## 怎么算
**公式**: `point_cnt`

依赖的底层指标:
- [[point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `point_cnt`
- [[point_amt]] (?) — `⚠️待D层` [待补] · 取数 `point_amt`
- [[online_num]] (?) — `⚠️待D层` [待补] · 取数 `online_num`
- [[point_active_cnt]] (?) — `⚠️待D层` [待补] · 取数 `point_active_cnt`
- [[point_register_cnt]] (?) — `⚠️待D层` [待补] · 取数 `point_register_cnt`
- [[point_pay_amt]] (?) — `⚠️待D层` [待补] · 取数 `point_pay_amt`
- [[create_role_point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `create_role_point_cnt`
- [[login_point_cnt]] (?) — `⚠️待D层` [待补] · 取数 `login_point_cnt`
- [[point_pay_cnt]] (?) — `⚠️待D层` [待补] · 取数 `point_pay_cnt`

## 数据来源
- 宽表: [[realtime_login]], [[realtime_charge]], [[realtime_create_role_test]], [[realtime_recurring]], [[realtime_online_cube_view]], [[dm_finance_role_zone_tz_di]], [[realtime_basic_create_role]], [[realtime_basic_login]], [[realtime_basic_charge]], [[realtime_basic_online]], [[realtime_create_role]], [[realtime_online_cube_view_mla]], [[realtime_online_nova_cube_view]], [[realtime_charge_cnt]], [[ads_realtime_batch_data_di]], [[realtime_online_cube_view_zgame]]
- dataset: ['300024', '300035', '300036', '300037', '300041', '300365', '300404', '300402', '300409', '300410', '300412', '300147', '300149', '300150', '300175', '200001', '300184', '300187', '300185', '300188', '300230', '300231', '300233', '300235', '300273', '300274', '300288', '300280', '300282', '300281', '300283', '300285', '300284', '300286', '300302', '300151']  · 产品线 scope: ['mlbb', 'lovania_cn', 'sgame_cn', 'tgame', 'aoz', 'wefly5', 'mlcn', 'wefly_cn', 'wegame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **point_cnt** @ `mt_ads_realtime.realtime_login`
  - 口径指针: `etl://mt_ads_realtime.realtime_login:point_cnt`(D 层未自动解析,待补)
- **point_amt** @ `mt_ads_realtime.realtime_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_charge:point_amt`(D 层未自动解析,待补)
- **online_num** @ `mt_ads_realtime.realtime_online_cube_view`
  - 口径指针: `etl://mt_ads_realtime.realtime_online_cube_view:online_num`(D 层未自动解析,待补)
- **point_active_cnt** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_role_zone_tz_di:point_active_cnt`(D 层未自动解析,待补)
- **point_register_cnt** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_role_zone_tz_di:point_register_cnt`(D 层未自动解析,待补)
- **point_pay_amt** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 口径指针: `etl://mt_dm.dm_finance_role_zone_tz_di:point_pay_amt`(D 层未自动解析,待补)
- **point_pay_cnt** @ `mt_ads_realtime.realtime_charge`
  - 口径指针: `etl://mt_ads_realtime.realtime_charge:point_pay_cnt`(D 层未自动解析,待补)

## 各产品线实例
- [[bar_value__aoz__300402]] (scope=aoz, dataset=300402, 宽表=mt_ads_realtime.realtime_basic_login)
- [[bar_value__aoz__300404]] (scope=aoz, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[bar_value__aoz__300409]] (scope=aoz, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[bar_value__aoz__300410]] (scope=aoz, dataset=300410, 宽表=mt_ads_realtime.realtime_basic_login)
- [[bar_value__aoz__300412]] (scope=aoz, dataset=300412, 宽表=mt_ads_realtime.realtime_basic_online)
- [[bar_value__lovania_cn__300365]] (scope=lovania_cn, dataset=300365, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[bar_value__lovania_cn__300404]] (scope=lovania_cn, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[bar_value__mlbb__300024]] (scope=mlbb, dataset=300024, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__mlbb__300035]] (scope=mlbb, dataset=300035, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__mlbb__300036]] (scope=mlbb, dataset=300036, 宽表=mt_ads_realtime.realtime_create_role_test)
- [[bar_value__mlbb__300037]] (scope=mlbb, dataset=300037, 宽表=mt_ads_realtime.realtime_recurring)
- [[bar_value__mlbb__300041]] (scope=mlbb, dataset=300041, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[bar_value__mlbb__300147]] (scope=mlbb, dataset=300147, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__mlbb__300149]] (scope=mlbb, dataset=300149, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__mlbb__300150]] (scope=mlbb, dataset=300150, 宽表=mt_ads_realtime.realtime_create_role)
- [[bar_value__mlbb__300175]] (scope=mlbb, dataset=300175, 宽表=mt_ads_realtime.realtime_online_cube_view_mla)
- [[bar_value__mlbb__300184]] (scope=mlbb, dataset=300184, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__mlbb__300187]] (scope=mlbb, dataset=300187, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__mlbb__300185]] (scope=mlbb, dataset=300185, 宽表=mt_ads_realtime.realtime_create_role)
- [[bar_value__mlbb__300188]] (scope=mlbb, dataset=300188, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[bar_value__mlbb__300230]] (scope=mlbb, dataset=300230, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__mlbb__300231]] (scope=mlbb, dataset=300231, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__mlbb__300233]] (scope=mlbb, dataset=300233, 宽表=mt_ads_realtime.realtime_create_role)
- [[bar_value__mlbb__300235]] (scope=mlbb, dataset=300235, 宽表=mt_ads_realtime.realtime_online_nova_cube_view)
- [[bar_value__mlbb__300151]] (scope=mlbb, dataset=300151, 宽表=mt_ads_realtime.realtime_online_cube_view_zgame)
- [[bar_value__mlcn__300024]] (scope=mlcn, dataset=300024, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__mlcn__300035]] (scope=mlcn, dataset=300035, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__mlcn__300036]] (scope=mlcn, dataset=300036, 宽表=mt_ads_realtime.realtime_create_role_test)
- [[bar_value__mlcn__200001]] (scope=mlcn, dataset=200001, 宽表=—)
- [[bar_value__mlcn__300041]] (scope=mlcn, dataset=300041, 宽表=mt_ads_realtime.realtime_online_cube_view)
- [[bar_value__sgame_cn__300365]] (scope=sgame_cn, dataset=300365, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[bar_value__sgame_cn__300404]] (scope=sgame_cn, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[bar_value__tgame__300402]] (scope=tgame, dataset=300402, 宽表=mt_ads_realtime.realtime_basic_login)
- [[bar_value__tgame__300404]] (scope=tgame, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[bar_value__tgame__300409]] (scope=tgame, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[bar_value__tgame__300410]] (scope=tgame, dataset=300410, 宽表=mt_ads_realtime.realtime_basic_login)
- [[bar_value__tgame__300412]] (scope=tgame, dataset=300412, 宽表=mt_ads_realtime.realtime_basic_online)
- [[bar_value__wefly5__300402]] (scope=wefly5, dataset=300402, 宽表=mt_ads_realtime.realtime_basic_login)
- [[bar_value__wefly5__300404]] (scope=wefly5, dataset=300404, 宽表=mt_ads_realtime.realtime_basic_create_role)
- [[bar_value__wefly5__300409]] (scope=wefly5, dataset=300409, 宽表=mt_ads_realtime.realtime_basic_charge)
- [[bar_value__wefly5__300410]] (scope=wefly5, dataset=300410, 宽表=mt_ads_realtime.realtime_basic_login)
- [[bar_value__wefly5__300412]] (scope=wefly5, dataset=300412, 宽表=mt_ads_realtime.realtime_basic_online)
- [[bar_value__wefly_cn__300273]] (scope=wefly_cn, dataset=300273, 宽表=mt_ads_realtime.realtime_create_role)
- [[bar_value__wefly_cn__300274]] (scope=wefly_cn, dataset=300274, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__wefly_cn__300288]] (scope=wefly_cn, dataset=300288, 宽表=mt_ads_realtime.realtime_create_role)
- [[bar_value__wegame__300280]] (scope=wegame, dataset=300280, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__wegame__300282]] (scope=wegame, dataset=300282, 宽表=mt_ads_realtime.realtime_create_role)
- [[bar_value__wegame__300281]] (scope=wegame, dataset=300281, 宽表=mt_ads_realtime.realtime_charge)
- [[bar_value__wegame__300283]] (scope=wegame, dataset=300283, 宽表=mt_ads_realtime.realtime_charge_cnt)
- [[bar_value__wegame__300285]] (scope=wegame, dataset=300285, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__wegame__300284]] (scope=wegame, dataset=300284, 宽表=mt_ads_realtime.realtime_login)
- [[bar_value__wegame__300286]] (scope=wegame, dataset=300286, 宽表=mt_ads_realtime.realtime_charge_cnt)
- [[bar_value__zgame_cn__300302]] (scope=zgame_cn, dataset=300302, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: core-dau · tier: 长尾