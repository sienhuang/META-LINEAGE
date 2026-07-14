# pay_cnt  `pay_cnt`

**业务口径**: 日均收入金额(定价) 或 日均税前流水金额，单位美元

## 怎么算
**公式**: `pay_cnt`

依赖的底层指标:
- [[pay_cnt]] (?) — `COALESCE(pay_cnt, 0) AS pay_cnt` [已确认] · 取数 `pay_cnt`
- [[roleid]] (?) — `t_charge.roleid` [已确认] · 取数 `roleid`

## 数据来源
- 宽表: [[ads_decismart_reten_ltv_di]], [[ads_decismart_pay_cube_di]], [[dm_finance_role_zone_tz_di]], [[ads_gamebi_roger_primary_di]], [[realtime_create_role]], [[realtime_charge]], [[realtime_charge_cnt]], [[ads_realtime_batch_data_di]]
- dataset: ['300218', '300343', '300090', '300344', '300089', '300314', '300198', '300196', '300276', '300275', '300265', '300266', '300263', '300293', '300351', '300353', '300300']  · 产品线 scope: ['lovania_cn', 'sgame_cn', 'mlbb', 'wefly_cn', 'wegame', 'zgame_cn']

## 字段生成逻辑(D 层)
- **pay_cnt** @ `mt_ads.ads_decismart_pay_cube_di`
  - 跨任务血缘链(`mt_ads.ads_decismart_pay_cube_di.pay_cnt`):
    - d0 `mt_ads.ads_decismart_pay_cube_di.pay_cnt` ⇐ `subquery:job.100025712_1:subquery_18.pay_cnt` [derived] `COALESCE(pay_cnt, 0) AS pay_cnt`
    - d0 `mt_ads.ads_decismart_pay_cube_di.pay_cnt` ⇐ `subquery:job.100026014_1:subquery_18.pay_cnt` [derived] `COALESCE(pay_cnt, 0) AS pay_cnt`
    - d1 `subquery:job.100025712_1:subquery_18.pay_cnt` ⇐ `cte:job.100025712_1:account_pay_di.roleid` [aggregated] `SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */`
    - d1 `subquery:job.100026014_1:subquery_18.pay_cnt` ⇐ `cte:job.100026014_1:account_pay_di.roleid` [aggregated] `SUM(IF(NOT pay_di.roleid IS NULL, 1, 0)) AS pay_cnt /* 充值人数 */`
    - d2 `cte:job.100025712_1:account_pay_di.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_di.roleid` [direct] `roleid`
    - d2 `cte:job.100026014_1:account_pay_di.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_di.roleid` [direct] `roleid`
- **roleid** @ `mt_dm.dm_finance_role_zone_tz_di`
  - 跨任务血缘链(`mt_dm.dm_finance_role_zone_tz_di.roleid`):
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041175_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041367_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041902_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041174_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100041176_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d0 `mt_dm.dm_finance_role_zone_tz_di.roleid` ⇐ `cte:job.100042046_1:t_charge.roleid` [direct] `t_charge.roleid`
    - d1 `cte:job.100041175_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041367_1:t_charge.roleid` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041902_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041174_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100041176_1:t_charge.roleid` ⇐ `mt_dwm.dwm_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d1 `cte:job.100042046_1:t_charge.roleid` ⇐ `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041772_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041891_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100042035_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_mcgg_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100042024_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041772_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041891_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041772_0:t2.roleid` [direct] `roleid`
    - d2 `mt_dwm.dwm_charge_role_zone_tz_di.roleid` ⇐ `subquery:job.100041891_0:t2.roleid` [direct] `roleid`

## 各产品线实例
- [[pay_cnt__lovania_cn__300218]] (scope=lovania_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[pay_cnt__mlbb__300343]] (scope=mlbb, dataset=300343, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[pay_cnt__mlbb__300090]] (scope=mlbb, dataset=300090, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[pay_cnt__mlbb__300344]] (scope=mlbb, dataset=300344, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[pay_cnt__mlbb__300089]] (scope=mlbb, dataset=300089, 宽表=mt_ads.ads_decismart_pay_cube_di)
- [[pay_cnt__mlbb__300314]] (scope=mlbb, dataset=300314, 宽表=mt_dm.dm_finance_role_zone_tz_di)
- [[pay_cnt__sgame_cn__300218]] (scope=sgame_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[pay_cnt__wefly_cn__300198]] (scope=wefly_cn, dataset=300198, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt__wefly_cn__300218]] (scope=wefly_cn, dataset=300218, 宽表=mt_ads.ads_decismart_reten_ltv_di)
- [[pay_cnt__wefly_cn__300196]] (scope=wefly_cn, dataset=300196, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt__wefly_cn__300276]] (scope=wefly_cn, dataset=300276, 宽表=mt_ads_realtime.realtime_create_role)
- [[pay_cnt__wefly_cn__300275]] (scope=wefly_cn, dataset=300275, 宽表=mt_ads_realtime.realtime_charge)
- [[pay_cnt__wegame__300265]] (scope=wegame, dataset=300265, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt__wegame__300266]] (scope=wegame, dataset=300266, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt__wegame__300263]] (scope=wegame, dataset=300263, 宽表=mt_ads.ads_gamebi_roger_primary_di)
- [[pay_cnt__wegame__300293]] (scope=wegame, dataset=300293, 宽表=mt_ads_realtime.realtime_charge_cnt)
- [[pay_cnt__zgame_cn__300351]] (scope=zgame_cn, dataset=300351, 宽表=—)
- [[pay_cnt__zgame_cn__300353]] (scope=zgame_cn, dataset=300353, 宽表=—)
- [[pay_cnt__zgame_cn__300300]] (scope=zgame_cn, dataset=300300, 宽表=mt_ads_realtime.ads_realtime_batch_data_di)

## 元信息
- 分类: pay-cnt · tier: 长尾