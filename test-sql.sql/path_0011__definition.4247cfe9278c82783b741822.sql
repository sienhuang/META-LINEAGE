-- all-production-sql path_id: 11
-- target_definition_id: definition.4247cfe9278c82783b741822
-- jobs: job.100039145_0 -> job.100033187_0
-- producer choice: field.table.mt_dm.dm_multi_decismart_core_df.is_active=definition.54ab89ff4b59462f0816c30c
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.4247cfe9278c82783b741822
-- inlined jobs: job.100039145_0 -> job.100033187_0
-- external boundary: wefly_dw.dwm_active_role_zone_di.logymd
-- WARNING: selected producer for mt_dm.dm_multi_decismart_core_df writes static partition appname='wefly', but downstream filters appname='mcgg'; this branch returns no rows
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
      basic.roleid AS accountid,
      -99999 AS zoneid,
      COALESCE(did, 'unknown') AS deviceid,
      COALESCE(basic.register_date, '1970-01-01') AS create_date,
      COALESCE(basic.country, 'unknown') AS country,
      COALESCE(first_network_name, 'unknown') AS network,
      -99999 AS network_group,
      -99999 AS new_type,
      COALESCE(basic.os_name, 'unknown') AS create_os,
      COALESCE(basic.create_channel, 'unknown') AS create_channel,
      -99999 AS create_install_label,
      COALESCE(act_df.last_active_os, 'unknown') AS last_active_os,
      COALESCE(act_df.last_active_channel, 'unknown') AS last_active_channel,
      -99999 AS last_active_install_label,
      IF(act.is_td = 1, 1, 0) AS is_active,
      COALESCE(act.online_dur, 0) AS online_dur,
      COALESCE(pay.pay_amt, 0) AS pay_amt,
      0 AS pay_amt_exrate,
      0 AS actual_pay_amt,
      0 AS is_recurring_14days,
      0 AS is_recurring_30days,
      COALESCE(act_df.last_active_date, '1970-01-01') AS last_active_date,
      COALESCE(pay_df.first_pay_date, '1970-01-01') AS first_pay_date,
      COALESCE(pay_df.last_pay_date, '1970-01-01') AS last_pay_date,
      -99999 AS is_create_arcade,
      -99999 AS is_active_arcade,
      is_first_create,
      1 AS zone_type,
      COALESCE(basic.is_cur_bot, -99999) AS is_cur_bot,
      COALESCE(basic.is_init_bot, -99999) AS is_init_bot,
      COALESCE(his_pay_amt, 0) AS his_pay_amt,
      'unknown' AS first_active_os,
      'unknown' AS first_active_channel,
      COALESCE(act.is_active_7days, 0) AS is_active_7days,
      COALESCE(act.is_active_30days, 0) AS is_active_30days,
      COALESCE(pay.year_pay_amt, 0) AS year_pay_amt,
      COALESCE(act.is_active_90days, 0) AS is_active_90days,
      COALESCE(act.activedays_7days, 0) AS activedays_7days,
      COALESCE(act.online_dur_7days, 0) AS online_dur_7days,
      COALESCE(pay_7d.pay_amt_7days, 0) AS pay_amt_7days,
      'wefly' AS appname,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM (
      SELECT
        roleid,
        is_acc_cur_bot AS is_cur_bot,
        is_acc_init_bot AS is_init_bot,
        os_name,
        is_first_create,
        create_channel,
        first_network_name,
        first_mt_country AS country,
        SUBSTRING(register_time, 1, 10) AS register_date,
        did
      FROM wefly_dw.dim_basic_role_zone_df
      WHERE
        logymd = '2026-05-31' AND is_formal_first_create = 1
    ) AS basic
    LEFT JOIN (
      SELECT
        roleid,
        SUM(IF(logymd = '2026-05-31', online_dur, 0)) AS online_dur,
        MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_active_7days,
        MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_active_30days,
        MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
        MAX(CASE WHEN logymd BETWEEN '2026-03-03' AND '2026-05-31' THEN 1 ELSE 0 END) AS is_active_90days,
        COUNT(DISTINCT IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', logymd, NULL)) AS activedays_7days,
        SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', online_dur, 0)) AS online_dur_7days
      FROM wefly_dw.dwm_active_role_zone_di
      WHERE
        logymd >= '2026-03-03' AND logymd <= '2026-05-31' AND zone_type = 1
      GROUP BY
        roleid
    ) AS act
      ON basic.roleid = act.roleid
    LEFT JOIN (
      SELECT
        roleid,
        MAX_BY(his_last_os_name, his_last_active_time) AS last_active_os,
        MAX_BY(his_last_channel, his_last_active_time) AS last_active_channel,
        MAX(SUBSTRING(his_last_active_time, 1, 10)) AS last_active_date
      FROM wefly_dw.dwm_active_role_zone_df
      WHERE
        logymd = '2026-05-31' AND zone_type = 1
      GROUP BY
        roleid
    ) AS act_df
      ON basic.roleid = act_df.roleid
    LEFT JOIN (
      SELECT
        roleid,
        SUM(IF(logymd = '2026-05-31', pay_amt, 0)) AS pay_amt,
        SUM(pay_amt) AS year_pay_amt
      FROM wefly_dw.dwm_charge_role_zone_di
      WHERE
        logymd <= '2026-05-31'
        AND logymd >= CONCAT(SUBSTRING('2026-05-31', 1, 4), '-01-01')
        AND zone_type = 1
      GROUP BY
        roleid
    ) AS pay
      ON basic.roleid = pay.roleid
    LEFT JOIN (
      SELECT
        roleid,
        SUM(his_pay_amt) AS his_pay_amt,
        MAX(SUBSTRING(his_first_pay_time, 1, 10)) AS first_pay_date,
        MAX(SUBSTRING(his_last_pay_time, 1, 10)) AS last_pay_date
      FROM wefly_dw.dwm_charge_role_zone_df
      WHERE
        logymd = '2026-05-31' AND appid = 'wefly' AND zone_type = 1
      GROUP BY
        roleid
    ) AS pay_df
      ON basic.roleid = pay_df.roleid
    LEFT JOIN (
      SELECT
        roleid,
        SUM(IF(logymd = '2026-05-31', pay_amt, 0)) AS pay_amt,
        SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', pay_amt, 0)) AS pay_amt_7days
      FROM wefly_dw.dwm_charge_role_zone_di
      WHERE
        logymd BETWEEN '2026-05-25' AND '2026-05-31' AND appid = 'wefly' AND zone_type = 1
      GROUP BY
        roleid
    ) AS pay_7d
      ON basic.roleid = pay_7d.roleid
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
      basic.roleid AS accountid,
      -99999 AS zoneid,
      COALESCE(did, 'unknown') AS deviceid,
      COALESCE(basic.register_date, '1970-01-01') AS create_date,
      COALESCE(basic.country, 'unknown') AS country,
      COALESCE(first_network_name, 'unknown') AS network,
      -99999 AS network_group,
      -99999 AS new_type,
      COALESCE(basic.os_name, 'unknown') AS create_os,
      COALESCE(basic.create_channel, 'unknown') AS create_channel,
      -99999 AS create_install_label,
      COALESCE(act_df.last_active_os, 'unknown') AS last_active_os,
      COALESCE(act_df.last_active_channel, 'unknown') AS last_active_channel,
      -99999 AS last_active_install_label,
      IF(act.is_td = 1, 1, 0) AS is_active,
      COALESCE(act.online_dur, 0) AS online_dur,
      COALESCE(pay.pay_amt, 0) AS pay_amt,
      0 AS pay_amt_exrate,
      0 AS actual_pay_amt,
      0 AS is_recurring_14days,
      0 AS is_recurring_30days,
      COALESCE(act_df.last_active_date, '1970-01-01') AS last_active_date,
      COALESCE(pay_df.first_pay_date, '1970-01-01') AS first_pay_date,
      COALESCE(pay_df.last_pay_date, '1970-01-01') AS last_pay_date,
      -99999 AS is_create_arcade,
      -99999 AS is_active_arcade,
      is_first_create,
      1 AS zone_type,
      COALESCE(basic.is_cur_bot, -99999) AS is_cur_bot,
      COALESCE(basic.is_init_bot, -99999) AS is_init_bot,
      COALESCE(his_pay_amt, 0) AS his_pay_amt,
      'unknown' AS first_active_os,
      'unknown' AS first_active_channel,
      COALESCE(act.is_active_7days, 0) AS is_active_7days,
      COALESCE(act.is_active_30days, 0) AS is_active_30days,
      COALESCE(pay.year_pay_amt, 0) AS year_pay_amt,
      COALESCE(act.is_active_90days, 0) AS is_active_90days,
      COALESCE(act.activedays_7days, 0) AS activedays_7days,
      COALESCE(act.online_dur_7days, 0) AS online_dur_7days,
      COALESCE(pay_7d.pay_amt_7days, 0) AS pay_amt_7days,
      'wefly' AS appname,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM (
      SELECT
        roleid,
        is_acc_cur_bot AS is_cur_bot,
        is_acc_init_bot AS is_init_bot,
        os_name,
        is_first_create,
        create_channel,
        first_network_name,
        first_mt_country AS country,
        SUBSTRING(register_time, 1, 10) AS register_date,
        did
      FROM wefly_dw.dim_basic_role_zone_df
      WHERE
        logymd = '2026-05-31' AND is_formal_first_create = 1
    ) AS basic
    LEFT JOIN (
      SELECT
        roleid,
        SUM(IF(logymd = '2026-05-31', online_dur, 0)) AS online_dur,
        MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_active_7days,
        MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_active_30days,
        MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
        MAX(CASE WHEN logymd BETWEEN '2026-03-03' AND '2026-05-31' THEN 1 ELSE 0 END) AS is_active_90days,
        COUNT(DISTINCT IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', logymd, NULL)) AS activedays_7days,
        SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', online_dur, 0)) AS online_dur_7days
      FROM wefly_dw.dwm_active_role_zone_di
      WHERE
        logymd >= '2026-03-03' AND logymd <= '2026-05-31' AND zone_type = 1
      GROUP BY
        roleid
    ) AS act
      ON basic.roleid = act.roleid
    LEFT JOIN (
      SELECT
        roleid,
        MAX_BY(his_last_os_name, his_last_active_time) AS last_active_os,
        MAX_BY(his_last_channel, his_last_active_time) AS last_active_channel,
        MAX(SUBSTRING(his_last_active_time, 1, 10)) AS last_active_date
      FROM wefly_dw.dwm_active_role_zone_df
      WHERE
        logymd = '2026-05-31' AND zone_type = 1
      GROUP BY
        roleid
    ) AS act_df
      ON basic.roleid = act_df.roleid
    LEFT JOIN (
      SELECT
        roleid,
        SUM(IF(logymd = '2026-05-31', pay_amt, 0)) AS pay_amt,
        SUM(pay_amt) AS year_pay_amt
      FROM wefly_dw.dwm_charge_role_zone_di
      WHERE
        logymd <= '2026-05-31'
        AND logymd >= CONCAT(SUBSTRING('2026-05-31', 1, 4), '-01-01')
        AND zone_type = 1
      GROUP BY
        roleid
    ) AS pay
      ON basic.roleid = pay.roleid
    LEFT JOIN (
      SELECT
        roleid,
        SUM(his_pay_amt) AS his_pay_amt,
        MAX(SUBSTRING(his_first_pay_time, 1, 10)) AS first_pay_date,
        MAX(SUBSTRING(his_last_pay_time, 1, 10)) AS last_pay_date
      FROM wefly_dw.dwm_charge_role_zone_df
      WHERE
        logymd = '2026-05-31' AND appid = 'wefly' AND zone_type = 1
      GROUP BY
        roleid
    ) AS pay_df
      ON basic.roleid = pay_df.roleid
    LEFT JOIN (
      SELECT
        roleid,
        SUM(IF(logymd = '2026-05-31', pay_amt, 0)) AS pay_amt,
        SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', pay_amt, 0)) AS pay_amt_7days
      FROM wefly_dw.dwm_charge_role_zone_di
      WHERE
        logymd BETWEEN '2026-05-25' AND '2026-05-31' AND appid = 'wefly' AND zone_type = 1
      GROUP BY
        roleid
    ) AS pay_7d
      ON basic.roleid = pay_7d.roleid
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
