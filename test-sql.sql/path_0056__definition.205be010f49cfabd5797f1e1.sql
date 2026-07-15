-- all-production-sql path_id: 56
-- target_definition_id: definition.205be010f49cfabd5797f1e1
-- jobs: job.100033425_0 -> job.100041408_0
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt=definition.ad30804a4d2f25701d7fb515
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.205be010f49cfabd5797f1e1
-- inlined jobs: job.100033425_0 -> job.100041408_0
-- external boundary: bi_test.dwm_zgame_active_role_zone_di.logymd
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition date_type='daily', but downstream filters date_type='monthly'; this branch returns no rows
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition appname='zgame', but downstream filters appname='mla'; this branch returns no rows
WITH zgame_feature_df AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY accountid ORDER BY create_role_date) AS rn
    FROM mt_dm.dm_zgame_behavior_feature_role_zone_df
    WHERE
      logymd = '2026-05-31' AND create_account_date <= '2026-05-31'
  )
  WHERE
    rn = 1
), t_pay_df AS (
  SELECT
    roleid,
    SUM(IF(logymd = '2026-05-31', pay_amt, 0)) AS pay_amt,
    SUM(COALESCE(pay_amt, 0)) AS total_pay_amt,
    SUM(IF(logymd BETWEEN '2026-01-01' AND '2026-05-31', pay_amt, 0)) AS year_pay_amt,
    SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', pay_amt, 0)) AS pay_amt_7days /* 近7日付费金额 */
  FROM mt_dwm.dwm_zgame_pay_role_zone_di
  WHERE
    logymd <= '2026-05-31'
    AND logymd >= '2023-07-01'
    AND (
      (
        zoneid = 1 OR zoneid BETWEEN 19001 AND 50000
      )
      OR (
        logymd >= '2023-07-13' AND zoneid BETWEEN 50001 AND 69999
      )
      OR (
        logymd >= '2024-03-27' AND zoneid >= 70001
      )
    )
  GROUP BY
    roleid
), active_info AS (
  SELECT
    roleid,
    MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
    MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_7d,
    MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_30d, /* MAX(IF(logymd BETWEEN '2026-05-18' AND '2026-05-31', 1, 0)) AS is_14d, */
    MAX(IF(logymd BETWEEN '2026-03-03' AND '2026-05-31', 1, 0)) AS is_90d,
    COUNT(DISTINCT IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', logymd, NULL)) AS activedays_7days, /* 近7日活跃天数 */
    SUM(IF(logymd = '2026-05-31', active_dur, 0)) AS online_dur,
    SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', active_dur, 0)) AS online_dur_7days,
    MAX(IF(logymd = '2026-05-24', 1, 0)) AS is_7ds, /* 7日前是否活跃 */
    MAX(IF(logymd = '2026-05-01', 1, 0)) AS is_30ds /* 30日前是否活跃 */
  FROM bi_test.dwm_zgame_active_role_zone_di
  WHERE
    logymd >= '2026-03-03' AND logymd <= '2026-05-31'
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
      country,
      'unknown' AS os,
      'unknown' AS network,
      COALESCE(register_cnt, 0) AS register_cnt,
      NULL AS pure_register_cnt,
      COALESCE(active_cnt, 0) AS active_cnt,
      COALESCE(active_cnt_30days, 0) AS active_cnt_30days,
      COALESCE(pay_cnt, 0) AS pay_cnt,
      COALESCE(pay_amt, 0) AS pay_amt,
      NULL AS active_pay_30d_cnt,
      NULL AS active_register_pay_30d_cnt,
      NULL AS active_register_30d_cnt,
      NULL AS recurring_cnt_30days,
      NULL AS nologin_cnt_30days,
      NULL AS pay_amt_exrate,
      COALESCE(active_cnt, 0) AS active_cnt_period, /* ARRAY(0, 0, 0, 0, 0, 0) AS register_reten_cnt, */ /* ARRAY(0, 0, 0, 0, 0, 0) AS recurring_reten_cnt, */ /* NULL AS pay_amt_exrate, */ /* ARRAY(0, 0, 0, 0, 0, 0) AS pure_reten_cnt, */ /* ARRAY(0, 0, 0, 0, 0, 0) AS old_reten_cnt, */
      COALESCE(pay_cnt, 0) AS pay_cnt_period,
      COALESCE(online_dur, 0) AS online_dur, /*	当日玩家总在线时长(单位：s) */
      NULL AS new_active_cnt, /*	新用户活跃玩家数 */
      COALESCE(register_cnt_total, 0) AS register_cnt_total, /*	历史总注册玩家数 */
      COALESCE(lose_cnt_7ds, 0) AS lose_cnt_7ds, /*	7日流失玩家数 */
      COALESCE(active_cnt_7ds, 0) AS active_cnt_7ds, /*	7日前DAU */
      COALESCE(lose_cnt_30ds, 0) AS lose_cnt_30ds, /*	30日流失玩家数 */
      COALESCE(active_cnt_30ds, 0) AS active_cnt_30ds, /*	30日前DAU */
      COALESCE(active_cnt_7days, 0) AS active_cnt_7days,
      COALESCE(year_pay_amt, 0) AS year_pay_amt,
      NULL AS year_before_tax_usd_amt,
      COALESCE(total_pay_amt, 0) AS his_pay_amt,
      NULL AS his_before_tax_usd_amt,
      NULL AS recurring_cnt_14days,
      NULL AS nologin_cnt_14days,
      NULL AS actual_pay_amt,
      user_type,
      NULL AS channel,
      COALESCE(active_cnt_90days, 0) AS active_cnt_90days,
      COALESCE(vaild_user_cnt, 0) AS vaild_user_cnt,
      COALESCE(vaild_user_online_dur, 0) AS vaild_user_online_dur,
      'zgame' AS appname,
      'daily' AS date_type,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM (
      SELECT
        first_mt_country AS country,
        COUNT(DISTINCT IF(create_account_date = '2026-05-31', accountid, NULL)) AS register_cnt,
        SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt,
        SUM(pay_amt) AS pay_amt,
        SUM(IF(pay_amt > 0, 1, 0)) AS pay_cnt,
        COUNT(DISTINCT IF(create_account_date <= '2026-05-31', accountid, NULL)) AS register_cnt_total,
        SUM(online_dur) AS online_dur,
        SUM(year_pay_amt) AS year_pay_amt,
        SUM(total_pay_amt) AS total_pay_amt,
        SUM(COALESCE(act_di.is_7d, 0)) AS active_cnt_7days,
        SUM(COALESCE(act_di.is_30d, 0)) AS active_cnt_30days,
        COALESCE(SUM(IF(act_di.is_7ds = 1 AND act_di.is_7d = 0, 1, 0)), 0) AS lose_cnt_7ds,
        COALESCE(SUM(IF(act_di.is_7ds = 1, 1, 0)), 0) AS active_cnt_7ds,
        COALESCE(SUM(IF(act_di.is_30ds = 1 AND act_di.is_30d = 0, 1, 0)), 0) AS lose_cnt_30ds,
        COALESCE(SUM(IF(act_di.is_30ds = 1, 1, 0)), 0) AS active_cnt_30ds,
        COALESCE(SUM(IF(act_di.is_90d = 1, 1, 0)), 0) AS active_cnt_90days,
        COALESCE(
          SUM(
            IF(act_di.is_td = 1 AND (
              act_di.activedays_7days >= 2 OR pay_amt_7days > 0
            ), 1, 0)
          ),
          0
        ) AS vaild_user_cnt,
        COALESCE(
          ROUND(
            SUM(
              IF(
                act_di.is_td = 1 AND (
                  act_di.activedays_7days >= 2 OR pay_amt_7days > 0
                ),
                act_di.online_dur_7days,
                0
              )
            ) / LEAST(DATEDIFF('2026-05-31', '2023-07-01') + 1, 7),
            0
          ),
          0
        ) AS vaild_user_online_dur,
        1 AS user_type
      FROM zgame_feature_df AS fet
      LEFT JOIN active_info AS act_di
        ON fet.accountid = act_di.roleid
      LEFT JOIN t_pay_df AS pay_di
        ON fet.accountid = pay_di.roleid
      GROUP BY
        first_mt_country
      UNION ALL
      SELECT
        first_mt_country AS country,
        COUNT(DISTINCT IF(create_account_date = '2026-05-31', accountid, NULL)) AS register_cnt,
        SUM(IF(act_di.is_td = 1, 1, 0)) AS active_cnt,
        SUM(pay_amt) AS pay_amt,
        SUM(IF(pay_amt > 0, 1, 0)) AS pay_cnt,
        COUNT(DISTINCT IF(create_account_date <= '2026-05-31', accountid, NULL)) AS register_cnt_total,
        SUM(online_dur) AS online_dur,
        SUM(year_pay_amt) AS year_pay_amt,
        SUM(total_pay_amt) AS total_pay_amt,
        SUM(COALESCE(act_di.is_7d, 0)) AS active_cnt_7days,
        SUM(COALESCE(act_di.is_30d, 0)) AS active_cnt_30days,
        COALESCE(SUM(IF(act_di.is_7ds = 1 AND act_di.is_7d = 0, 1, 0)), 0) AS lose_cnt_7ds,
        COALESCE(SUM(IF(act_di.is_7ds = 1, 1, 0)), 0) AS active_cnt_7ds,
        COALESCE(SUM(IF(act_di.is_30ds = 1 AND act_di.is_30d = 0, 1, 0)), 0) AS lose_cnt_30ds,
        COALESCE(SUM(IF(act_di.is_30ds = 1, 1, 0)), 0) AS active_cnt_30ds,
        COALESCE(SUM(IF(act_di.is_90d = 1, 1, 0)), 0) AS active_cnt_90days,
        COALESCE(
          SUM(
            IF(act_di.is_td = 1 AND (
              act_di.activedays_7days >= 2 OR pay_amt_7days > 0
            ), 1, 0)
          ),
          0
        ) AS vaild_user_cnt,
        COALESCE(
          ROUND(
            SUM(
              IF(
                act_di.is_td = 1 AND (
                  act_di.activedays_7days >= 2 OR pay_amt_7days > 0
                ),
                act_di.online_dur_7days,
                0
              )
            ) / LEAST(DATEDIFF('2026-05-31', '2023-07-01') + 1, 7),
            0
          ),
          0
        ) AS vaild_user_online_dur,
        2 AS user_type
      FROM zgame_feature_df AS fet
      LEFT JOIN active_info AS act_di
        ON fet.accountid = act_di.roleid
      LEFT JOIN t_pay_df AS pay_di
        ON fet.accountid = pay_di.roleid
      WHERE
        fet.is_cur_bot = 0
      GROUP BY
        first_mt_country
    )
  ) AS ads_gamebi_roger_primary_di_mid
  WHERE
    logymd = '2026-05-31' /* and logymd >= '2025-08-27' */
    AND appname = 'mla'
    AND granularity_type = 'account'
    AND date_type = 'monthly'
) AS a;
