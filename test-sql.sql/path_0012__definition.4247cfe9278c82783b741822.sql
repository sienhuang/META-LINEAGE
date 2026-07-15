-- all-production-sql path_id: 12
-- target_definition_id: definition.4247cfe9278c82783b741822
-- jobs: job.100033088_0 -> job.100033187_0
-- producer choice: field.table.mt_dm.dm_multi_decismart_core_df.is_active=definition.5f6390468645e6999ac1e9bb
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.4247cfe9278c82783b741822
-- inlined jobs: job.100033088_0 -> job.100033187_0
-- external boundary: mcgg_dwm.dwm_active_role_zone_di.logymd
WITH basic AS (
  SELECT
    roleid,
    create_role_date AS create_date,
    CASE
      WHEN new_type = '模拟器新增'
      THEN 2
      WHEN new_type = '纯净新增'
      THEN 3
      WHEN new_type = '切号新增(被切号)'
      THEN 4
      WHEN new_type = '灰产新增'
      THEN 6
      ELSE -99999
    END AS new_type,
    IF(
      first_mt_country = '' OR first_mt_country = '-' OR first_mt_country IS NULL,
      'unknown',
      first_mt_country
    ) AS country,
    IF(
      first_media_source = '' OR first_media_source = '-' OR first_media_source IS NULL,
      'unknown',
      first_media_source
    ) AS network,
    IF(LOWER(first_media_source) = 'organic', 1, 2) AS network_group,
    IF(
      create_role_os_name = ''
      OR create_role_os_name = '-'
      OR create_role_os_name IS NULL,
      'unknown',
      create_role_os_name
    ) AS create_os,
    IF(
      create_role_channel = ''
      OR create_role_channel = '-'
      OR create_role_channel IS NULL,
      'unknown',
      create_role_channel
    ) AS create_channel,
    IF(role_type = '' OR role_type = '-' OR role_type IS NULL, -99999, role_type) AS create_install_label,
    is_yl AS is_create_arcade
  FROM mcgg_dim.dim_basic_role_zone_df_decismart
  WHERE
    logymd = IF('2026-05-31' <= '2025-05-01', '2025-05-01', '2026-05-31')
    AND is_first_create = 1
    AND create_role_date <= '2026-05-31'
), active_all_account_df AS (
  SELECT
    roleid,
    zoneid,
    IF(
      last_active_os = '' OR last_active_os = '-' OR last_active_os IS NULL,
      'unknown',
      last_active_os
    ) AS last_active_os,
    IF(
      his_last_channel = '' OR his_last_channel = '-' OR his_last_channel IS NULL,
      'unknown',
      his_last_channel
    ) AS last_active_channel,
    IF(
      day_ml_install = '' OR day_ml_install = '-' OR day_ml_install IS NULL,
      -99999,
      day_ml_install
    ) AS last_active_install_label,
    his_last_active_time,
    his_last_active_date AS last_active_date
  FROM (
    SELECT
      *,
      IF(
        his_last_channel LIKE '%%ios_%%',
        'ios',
        IF(his_last_channel LIKE '%%and_%%', 'android', his_last_os_name)
      ) AS last_active_os,
      ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY his_last_active_time DESC) AS rn
    FROM mcgg_dwm.dwm_active_role_zone_df
    WHERE
      logymd = '2026-05-31'
  )
  WHERE
    rn = 1
), active_all_account AS (
  SELECT
    roleid,
    MAX(IF(logymd = '2026-05-31', day_yl_active, 0)) AS is_active_arcade,
    MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
    MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_7d,
    MAX(IF(logymd BETWEEN '2026-05-18' AND '2026-05-31', 1, 0)) AS is_14d,
    MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_30d,
    MAX(IF(logymd BETWEEN '2026-05-24' AND '2026-05-30', 1, 0)) AS is_1_7d,
    MAX(IF(logymd BETWEEN '2026-05-17' AND '2026-05-30', 1, 0)) AS is_1_14d,
    MAX(IF(logymd BETWEEN '2026-05-01' AND '2026-05-30', 1, 0)) AS is_1_30d,
    SUM(IF(logymd = '2026-05-31', day_online_dur, 0)) AS online_dur,
    MAX(IF(logymd = '2026-05-24', 1, 0)) AS is_7ds, /* 7日前是否活跃 */
    MAX(IF(logymd = '2026-05-01', 1, 0)) AS is_30ds /* 30日前是否活跃 */
  FROM mcgg_dwm.dwm_active_role_zone_di
  WHERE
    logymd BETWEEN '2026-05-01' AND '2026-05-31'
  GROUP BY
    roleid
), account_pay_di AS (
  SELECT
    roleid,
    SUM(IF(logymd = '2026-05-31', product_money, 0)) AS pay_amt,
    SUM(IF(logymd = '2026-05-31', before_tax_usd_amt, 0)) AS pay_amt_exrate,
    SUM(IF(logymd = '2026-05-31', pay_net_receipts_usd_amt, 0)) AS actual_pay_amt
  FROM mt_dwm.dwm_mcgg_charge_role_zone_di
  WHERE
    logymd = '2026-05-31' AND before_tax_usd_amt > 0
  GROUP BY
    roleid
), account_pay_df AS (
  SELECT
    roleid,
    SUBSTRING(MIN(his_first_pay_time), 1, 10) AS first_pay_date,
    SUBSTRING(MAX(his_last_pay_time), 1, 10) AS last_pay_date
  FROM mt_dwm.dwm_mcgg_charge_role_zone_df
  WHERE
    logymd = '2026-05-31' AND his_before_tax_usd_amt > 0
  GROUP BY
    roleid
)
SELECT
  COALESCE(SUM(b.active_days), 0) AS active_cnt
FROM (
  SELECT
    country,
    last_active_os AS os,
    last_active_channel AS channel,
    network_group,
    new_type,
    last_active_install_label AS install_label,
    accountid
  FROM (
    SELECT
      bas.roleid AS accountid, /*	角色id,key */
      -99999 AS zoneid, /*	服务器,key */
      'unknown' AS deviceid, /*	设备id */
      bas.create_date, /*	注册日期 */
      bas.country, /*	国家(归因国)（新增属性） */
      bas.network, /*	广告渠道（新增属性） */
      bas.network_group, /*	广告渠道分组（新增属性） */
      bas.new_type, /*	玩家新增类型（新增属性） */
      bas.create_os, /*	系统类型（新增属性） */
      bas.create_channel, /*	渠道（新增属性） */
      bas.create_install_label, /*	玩家安装类型标签（新增属性） */
      COALESCE(act_df.last_active_os, bas.create_os) AS last_active_os, /*	末次登录系统类型（活跃属性） */
      COALESCE(act_df.last_active_channel, bas.create_channel) AS last_active_channel, /*	末次登录渠道（活跃属性） */
      COALESCE(act_df.last_active_install_label, bas.create_install_label) AS last_active_install_label, /*	末次登录玩家安装类型标签（活跃属性） */
      IF(act.is_td = 1, 1, 0) AS is_active, /*	当日是否活跃(1:是，0:否) */
      COALESCE(act.online_dur, 0) AS online_dur, /*	当日在线时长 */
      COALESCE(pay_di.pay_amt, 0) AS pay_amt, /*	充值金额(美分) */
      COALESCE(pay_di.pay_amt_exrate, 0) AS pay_amt_exrate, /*	汇率校准付费金额(美分) */
      COALESCE(pay_di.actual_pay_amt, 0) AS actual_pay_amt, /*	实收金额(美分) */
      IF(
        act.is_td = 1
        AND act.is_1_14d <> 1
        AND bas.create_date < '2026-05-17'
        AND '2026-05-31' >= DATE_ADD('2024-11-28', 14),
        1,
        0
      ) AS is_recurring_14days,
      IF(
        act.is_td = 1
        AND act.is_1_30d <> 1
        AND bas.create_date < '2026-05-01'
        AND '2026-05-31' >= DATE_ADD('2024-11-28', 30),
        1,
        0
      ) AS is_recurring_30days, /*	当日是否30日回流(1:是，0:否) */
      COALESCE(act_df.last_active_date, '1970-01-01') AS last_active_date, /*	末次活跃日期 */
      COALESCE(pay_df.first_pay_date, '1970-01-01') AS first_pay_date, /*	首次付费日期 */
      COALESCE(pay_df.last_pay_date, '1970-01-01') AS last_pay_date, /*	末次付费日期 */
      COALESCE(bas.is_create_arcade, 0) AS is_create_arcade,
      COALESCE(act.is_active_arcade, 0) AS is_active_arcade,
      1 AS is_first_create,
      1 AS zone_type,
      0 AS is_cur_bot,
      0 AS is_init_bot,
      NULL AS his_pay_amt,
      NULL AS first_active_os,
      NULL AS first_active_channel,
      0 AS is_active_7days,
      0 AS is_active_30days,
      0 AS year_pay_amt,
      0 AS is_active_90days,
      0 AS activedays_7days,
      0 AS online_dur_7days,
      0 AS pay_amt_7days,
      'mcgg' AS appname,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM basic AS bas
    LEFT JOIN active_all_account AS act
      ON bas.roleid = act.roleid
    LEFT JOIN active_all_account_df AS act_df
      ON bas.roleid = act_df.roleid
    LEFT JOIN account_pay_di AS pay_di
      ON bas.roleid = pay_di.roleid
    LEFT JOIN account_pay_df AS pay_df
      ON bas.roleid = pay_df.roleid
  ) AS dm_multi_decismart_core_df
  WHERE
    logymd = '2026-05-31' AND appname = 'mcgg' AND granularity_type = 'account'
) AS a
LEFT JOIN (
  SELECT
    accountid,
    MAX(is_active) AS is_active,
    SUM(IF(is_active = 1, 1, 0)) AS active_days /* 活跃天数 */
  FROM (
    SELECT
      bas.roleid AS accountid, /*	角色id,key */
      -99999 AS zoneid, /*	服务器,key */
      'unknown' AS deviceid, /*	设备id */
      bas.create_date, /*	注册日期 */
      bas.country, /*	国家(归因国)（新增属性） */
      bas.network, /*	广告渠道（新增属性） */
      bas.network_group, /*	广告渠道分组（新增属性） */
      bas.new_type, /*	玩家新增类型（新增属性） */
      bas.create_os, /*	系统类型（新增属性） */
      bas.create_channel, /*	渠道（新增属性） */
      bas.create_install_label, /*	玩家安装类型标签（新增属性） */
      COALESCE(act_df.last_active_os, bas.create_os) AS last_active_os, /*	末次登录系统类型（活跃属性） */
      COALESCE(act_df.last_active_channel, bas.create_channel) AS last_active_channel, /*	末次登录渠道（活跃属性） */
      COALESCE(act_df.last_active_install_label, bas.create_install_label) AS last_active_install_label, /*	末次登录玩家安装类型标签（活跃属性） */
      IF(act.is_td = 1, 1, 0) AS is_active, /*	当日是否活跃(1:是，0:否) */
      COALESCE(act.online_dur, 0) AS online_dur, /*	当日在线时长 */
      COALESCE(pay_di.pay_amt, 0) AS pay_amt, /*	充值金额(美分) */
      COALESCE(pay_di.pay_amt_exrate, 0) AS pay_amt_exrate, /*	汇率校准付费金额(美分) */
      COALESCE(pay_di.actual_pay_amt, 0) AS actual_pay_amt, /*	实收金额(美分) */
      IF(
        act.is_td = 1
        AND act.is_1_14d <> 1
        AND bas.create_date < '2026-05-17'
        AND '2026-05-31' >= DATE_ADD('2024-11-28', 14),
        1,
        0
      ) AS is_recurring_14days,
      IF(
        act.is_td = 1
        AND act.is_1_30d <> 1
        AND bas.create_date < '2026-05-01'
        AND '2026-05-31' >= DATE_ADD('2024-11-28', 30),
        1,
        0
      ) AS is_recurring_30days, /*	当日是否30日回流(1:是，0:否) */
      COALESCE(act_df.last_active_date, '1970-01-01') AS last_active_date, /*	末次活跃日期 */
      COALESCE(pay_df.first_pay_date, '1970-01-01') AS first_pay_date, /*	首次付费日期 */
      COALESCE(pay_df.last_pay_date, '1970-01-01') AS last_pay_date, /*	末次付费日期 */
      COALESCE(bas.is_create_arcade, 0) AS is_create_arcade,
      COALESCE(act.is_active_arcade, 0) AS is_active_arcade,
      1 AS is_first_create,
      1 AS zone_type,
      0 AS is_cur_bot,
      0 AS is_init_bot,
      NULL AS his_pay_amt,
      NULL AS first_active_os,
      NULL AS first_active_channel,
      0 AS is_active_7days,
      0 AS is_active_30days,
      0 AS year_pay_amt,
      0 AS is_active_90days,
      0 AS activedays_7days,
      0 AS online_dur_7days,
      0 AS pay_amt_7days,
      'mcgg' AS appname,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM basic AS bas
    LEFT JOIN active_all_account AS act
      ON bas.roleid = act.roleid
    LEFT JOIN active_all_account_df AS act_df
      ON bas.roleid = act_df.roleid
    LEFT JOIN account_pay_di AS pay_di
      ON bas.roleid = pay_di.roleid
    LEFT JOIN account_pay_df AS pay_df
      ON bas.roleid = pay_df.roleid
  ) AS dm_multi_decismart_core_df
  WHERE
    logymd BETWEEN DATE_FORMAT('2026-05-31', 'yyyy-MM-01') AND LAST_DAY('2026-05-31')
    AND appname = 'mcgg'
    AND granularity_type = 'account'
  GROUP BY
    accountid
) AS b
  ON a.accountid = b.accountid
GROUP BY
  country,
  os,
  channel,
  network_group,
  new_type,
  install_label;
