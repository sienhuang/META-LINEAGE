-- all-production-sql path_id: 44
-- target_definition_id: definition.b6d99ffe31d14f27d216d55b
-- jobs: job.100033331_0 -> job.100041407_0
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt=definition.71120ff18e1ca7f43c1a73e6
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.b6d99ffe31d14f27d216d55b
-- inlined jobs: job.100033331_0 -> job.100041407_0
-- external boundary: mcgg_dwm.dwm_active_role_zone_di.logymd
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition date_type='daily', but downstream filters date_type='monthly'; this branch returns no rows
WITH basic AS (
  SELECT
    roleid,
    create_role_date AS register_date,
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
    IF(role_type = '' OR role_type = '-' OR role_type IS NULL, -99999, role_type) AS create_install_label
  FROM mcgg_dim.dim_basic_role_zone_df
  WHERE
    logymd = IF('2026-05-31' <= '2025-04-20', '2025-04-20', '2026-05-31')
    AND is_first_create = 1
    AND create_role_date <= '2026-05-31'
), active_all_account AS (
  SELECT
    roleid,
    MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
    MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_7d,
    MAX(IF(logymd BETWEEN '2026-05-18' AND '2026-05-31', 1, 0)) AS is_14d,
    MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_30d,
    MAX(IF(logymd BETWEEN '2026-05-24' AND '2026-05-30', 1, 0)) AS is_1_7d,
    MAX(IF(logymd BETWEEN '2026-05-17' AND '2026-05-30', 1, 0)) AS is_1_14d,
    MAX(IF(logymd BETWEEN '2026-05-01' AND '2026-05-30', 1, 0)) AS is_1_30d,
    SUM(IF(logymd = '2026-05-31', day_online_dur, 0)) AS online_dur,
    MAX(IF(logymd = '2026-05-24', 1, 0)) AS is_7ds, /* 7日前是否活跃 */
    MAX(IF(logymd = '2026-05-01', 1, 0)) AS is_30ds, /* 30日前是否活跃 */
    MAX(IF(logymd BETWEEN '2026-03-03' AND '2026-05-31', 1, 0)) AS is_90d, /* 近90天是否活跃 */
    COUNT(DISTINCT IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', logymd, NULL)) AS activedays_7days, /* 近7日活跃天数 */
    SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', day_online_dur, 0)) AS online_dur_7days
  FROM mcgg_dwm.dwm_active_role_zone_di
  WHERE
    logymd BETWEEN '2026-03-03' AND '2026-05-31'
  GROUP BY
    roleid
), account_pay_di AS (
  SELECT
    roleid,
    SUM(IF(logymd = '2026-05-31', product_money, 0)) AS pay_amt,
    SUM(IF(logymd = '2026-05-31', before_tax_usd_amt, 0)) AS pay_amt_exrate,
    SUM(IF(logymd = '2026-05-31', pay_net_receipts_usd_amt, 0)) AS actual_pay_amt,
    SUM(product_money) AS year_pay_amt,
    SUM(before_tax_usd_amt) AS year_before_tax_usd_amt
  FROM mt_dwm.dwm_mcgg_charge_role_zone_di
  WHERE
    logymd <= '2026-05-31'
    AND logymd >= CONCAT(SUBSTRING('2026-05-31', 1, 4), '-01-01')
    AND logymd >= '2024-11-28'
    AND before_tax_usd_amt > 0
  GROUP BY
    roleid
), account_pay_df AS (
  SELECT
    roleid,
    MIN(logymd) AS his_first_pay_date,
    MAX(logymd) AS his_last_pay_date,
    SUM(product_money) AS his_pay_amt,
    SUM(before_tax_usd_amt) AS his_before_tax_usd_amt,
    SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', product_money, 0)) AS pay_amt_7days /* 近7日付费金额 */
  FROM mt_dwm.dwm_mcgg_charge_role_zone_di
  WHERE
    logymd <= '2026-05-31' AND logymd >= '2024-11-28' AND before_tax_usd_amt > 0
  GROUP BY
    roleid
)
SELECT
  COALESCE(active_cnt, 0) AS active_cnt
FROM (
  SELECT
    SUBSTRING(logymd, 1, 7) AS date_range,
    country,
    os,
    network,
    register_cnt,
    pure_register_cnt,
    active_cnt,
    active_cnt_30days,
    pay_cnt,
    pay_amt,
    active_pay_30d_cnt,
    active_register_pay_30d_cnt,
    active_register_30d_cnt,
    recurring_cnt_30days,
    nologin_cnt_30days,
    pay_amt_exrate,
    online_dur,
    new_active_cnt,
    register_cnt_total,
    lose_cnt_7ds,
    active_cnt_7ds,
    lose_cnt_30ds,
    active_cnt_30ds,
    recurring_cnt_14days,
    nologin_cnt_14days,
    actual_pay_amt,
    active_cnt_period,
    pay_cnt_period,
    channel,
    user_type,
    logymd
  FROM (
    SELECT
      '2026-05-31' AS date_range,
      COALESCE(bas.country, 'unknown') AS country,
      'unknown' AS os,
      'unknown' AS network,
      COALESCE(SUM(IF(bas.register_date = '2026-05-31', 1, 0)), 0) AS register_cnt,
      COALESCE(SUM(IF(bas.register_date = '2026-05-31' AND bas.new_type = 3, 1, 0)), 0) AS pure_register_cnt,
      COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt,
      COALESCE(SUM(IF(act.is_30d = 1, 1, 0)), 0) AS active_cnt_30days,
      COALESCE(SUM(IF(pay_di.pay_amt > 0, 1, 0)), 0) AS pay_cnt,
      COALESCE(SUM(pay_di.pay_amt), 0) AS pay_amt,
      COALESCE(
        SUM(
          IF(
            act.is_td = 1 AND pay_df.his_last_pay_date BETWEEN '2026-05-02' AND '2026-05-31',
            1,
            0
          )
        ),
        0
      ) AS active_pay_30d_cnt,
      COALESCE(
        SUM(
          IF(
            act.is_td = 1
            AND bas.register_date = '2026-05-02'
            AND pay_df.his_last_pay_date BETWEEN '2026-05-02' AND '2026-05-31',
            1,
            0
          )
        ),
        0
      ) AS active_register_pay_30d_cnt,
      COALESCE(SUM(IF(act.is_td = 1 AND bas.register_date = '2026-05-02', 1, 0)), 0) AS active_register_30d_cnt,
      COALESCE(
        SUM(
          IF(
            act.is_td = 1
            AND act.is_1_30d <> 1
            AND bas.register_date < '2026-05-01'
            AND '2026-05-31' >= DATE_ADD('2024-11-28', 30),
            1,
            0
          )
        ),
        0
      ) AS recurring_cnt_30days,
      COALESCE(
        SUM(
          IF(
            bas.register_date <= '2026-04-30'
            AND COALESCE(act.is_1_30d, 0) = 0
            AND '2026-05-31' >= DATE_ADD('2024-11-28', 30),
            1,
            0
          )
        ),
        0
      ) AS nologin_cnt_30days,
      COALESCE(SUM(pay_di.pay_amt_exrate), 0) AS pay_amt_exrate,
      COALESCE(SUM(IF(act.is_td = 1, 1, 0)), 0) AS active_cnt_period,
      COALESCE(SUM(IF(pay_di.pay_amt > 0, 1, 0)), 0) AS pay_cnt_period,
      COALESCE(SUM(act.online_dur), 0) AS online_dur,
      COALESCE(
        SUM(
          IF(
            bas.register_date >= '2026-05-02'
            AND bas.register_date <= '2026-05-31'
            AND act.is_td = 1,
            1,
            0
          )
        ),
        0
      ) AS new_active_cnt,
      COALESCE(COUNT(*), 0) AS register_cnt_total,
      COALESCE(SUM(IF(act.is_7ds = 1 AND act.is_7d = 0, 1, 0)), 0) AS lose_cnt_7ds,
      COALESCE(SUM(IF(act.is_7ds = 1, 1, 0)), 0) AS active_cnt_7ds,
      COALESCE(SUM(IF(act.is_30ds = 1 AND act.is_30d = 0, 1, 0)), 0) AS lose_cnt_30ds,
      COALESCE(SUM(IF(act.is_30ds = 1, 1, 0)), 0) AS active_cnt_30ds,
      COALESCE(SUM(IF(act.is_7d = 1, 1, 0)), 0) AS active_cnt_7days,
      COALESCE(SUM(pay_di.year_pay_amt), 0) AS year_pay_amt,
      COALESCE(SUM(pay_di.year_before_tax_usd_amt), 0) AS year_before_tax_usd_amt,
      COALESCE(SUM(pay_df.his_pay_amt), 0) AS his_pay_amt,
      COALESCE(SUM(pay_df.his_before_tax_usd_amt), 0) AS his_before_tax_usd_amt,
      COALESCE(
        SUM(
          IF(
            act.is_td = 1
            AND act.is_1_14d <> 1
            AND bas.register_date < '2026-05-17'
            AND '2026-05-31' >= DATE_ADD('2024-11-28', 14),
            1,
            0
          )
        ),
        0
      ) AS recurring_cnt_14days,
      COALESCE(
        SUM(
          IF(
            bas.register_date <= '2026-05-16'
            AND COALESCE(act.is_1_14d, 0) = 0
            AND '2026-05-31' >= DATE_ADD('2024-11-28', 14),
            1,
            0
          )
        ),
        0
      ) AS nologin_cnt_14days,
      COALESCE(SUM(pay_di.actual_pay_amt), 0) AS actual_pay_amt,
      2 AS user_type,
      NULL AS channel,
      COALESCE(SUM(IF(act.is_90d = 1, 1, 0)), 0) AS active_cnt_90days,
      COALESCE(
        SUM(IF(act.is_td = 1 AND (
          act.activedays_7days >= 2 OR pay_amt_7days > 0
        ), 1, 0)),
        0
      ) AS vaild_user_cnt,
      COALESCE(
        ROUND(
          SUM(
            IF(
              act.is_td = 1 AND (
                act.activedays_7days >= 2 OR pay_amt_7days > 0
              ),
              act.online_dur_7days,
              0
            )
          ) / LEAST(DATEDIFF('2026-05-31', '2024-11-28') + 1, 7),
          0
        ),
        0
      ) AS vaild_user_online_dur,
      'mcgg_v2' AS appname,
      'daily' AS date_type,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM basic AS bas
    LEFT JOIN active_all_account AS act
      ON bas.roleid = act.roleid
    LEFT JOIN account_pay_di AS pay_di
      ON bas.roleid = pay_di.roleid
    LEFT JOIN account_pay_df AS pay_df
      ON bas.roleid = pay_df.roleid
    GROUP BY
      COALESCE(bas.country, 'unknown')
  ) AS ads_gamebi_roger_primary_di_mid
  WHERE
    logymd = '2026-05-31' /* and logymd >= '2025-08-27' */
    AND appname = 'mcgg_v2'
    AND granularity_type = 'account'
    AND date_type = 'monthly'
) AS a;
