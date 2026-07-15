-- all-production-sql path_id: 39
-- target_definition_id: definition.37e1179df291930c9974e57d
-- jobs: job.100032988_0 -> job.100041406_0
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt=definition.a98768ce384e26f101a91189
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.37e1179df291930c9974e57d
-- inlined jobs: job.100032988_0 -> job.100041406_0
-- external boundary: mt_dwm.dwm_mla_active_role_zone_di.logymd
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition date_type='daily', but downstream filters date_type='monthly'; this branch returns no rows
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition appname='mla', but downstream filters appname='nova'; this branch returns no rows
WITH basic AS (
  SELECT
    *
  FROM (
    SELECT
      roleid,
      zoneid,
      first_mt_country AS country,
      SUBSTRING(register_date, 1, 10) AS register_date,
      IF(os = 'unknown', '', os) AS register_os,
      IF(first_network_name = 'unknown', '', first_network_name) AS first_network_name,
      ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY register_date) AS rn
    FROM mt_dim.dim_mla_basic_role_zone_df
    WHERE
      logymd = '2026-05-31' AND logymd >= '2019-02-28' /* 限制上线日期 */
  ) AS t
  WHERE
    rn = 1
), active_di AS (
  SELECT
    roleid,
    MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
    MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_7d,
    MAX(IF(logymd BETWEEN '2026-05-18' AND '2026-05-31', 1, 0)) AS is_14d,
    MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_30d,
    SUM(IF(logymd = '2026-05-31', login_duration, 0)) AS online_dur, /* MAX(IF(logymd BETWEEN '2026-05-24' AND '2026-05-30', 1, 0)) AS is_1_7d, */ /* MAX(IF(logymd BETWEEN '2026-05-17' AND '2026-05-30', 1, 0)) AS is_1_14d, */ /* MAX(IF(logymd BETWEEN '2026-05-01' AND '2026-05-30', 1, 0)) AS is_1_30d, */
    MAX(IF(logymd BETWEEN '2026-03-03' AND '2026-05-31', 1, 0)) AS is_90d, /* MAX(IF(logymd = '2026-05-24', 1, 0)) AS is_7ds, --7日前是否活跃 */ /* MAX(IF(logymd = '2026-05-01', 1, 0)) AS is_30ds --30日前是否活跃 */ /* 近90天是否活跃 */
    COUNT(DISTINCT IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', logymd, NULL)) AS activedays_7days, /* 近7日活跃天数 */
    SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', login_duration, 0)) AS online_dur_7days
  FROM mt_dwm.dwm_mla_active_role_zone_di
  WHERE
    logymd BETWEEN '2026-03-03' AND '2026-05-31'
    AND login_cnt > 0 /* 代表活跃 */
    AND logymd >= '2019-02-28' /* 限制上线日期 */
  GROUP BY
    roleid
), pay_di AS (
  SELECT
    roleid,
    SUM(IF(logymd = '2026-05-31', charge_money, 0)) AS pay_amt, /* SUM(if(logymd = '2026-05-31' , charge_cnt, 0)) AS charge_cnt, */
    SUM(charge_money) AS his_pay_amt,
    SUM(IF(logymd BETWEEN '2026-01-01' AND '2026-05-31', charge_money, 0)) AS year_pay_amt,
    SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', charge_money, 0)) AS pay_amt_7days /* 近7日付费金额 */
  FROM mt_dwm.dwm_mla_pay_role_zone_di
  WHERE
    logymd <= '2026-05-31' AND logymd >= '2019-02-28' /* 限制上线日期 */
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
    pay_cnt_period,
    active_cnt_period,
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
      0 AS pure_register_cnt,
      COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt,
      COALESCE(SUM(IF(COALESCE(act_di.is_30d, 0) = 1, 1, 0)), 0) AS active_cnt_30days,
      COALESCE(SUM(IF(pay_di.pay_amt > 0, 1, 0)), 0) AS pay_cnt,
      COALESCE(SUM(pay_di.pay_amt), 0) AS pay_amt,
      0 AS active_pay_30d_cnt,
      0 AS active_register_pay_30d_cnt,
      0 AS active_register_30d_cnt,
      0 AS recurring_cnt_30days,
      0 AS nologin_cnt_30days,
      0 AS pay_amt_exrate,
      COALESCE(SUM(IF(COALESCE(act_di.is_td, 0) = 1, 1, 0)), 0) AS active_cnt_period,
      COALESCE(SUM(IF(pay_di.pay_amt > 0, 1, 0)), 0) AS pay_cnt_period,
      SUM(COALESCE(act_di.online_dur, 0)) AS online_dur, /*	当日玩家总在线时长(单位：s) */
      0 AS new_active_cnt, /*	新用户活跃玩家数 */
      COALESCE(SUM(IF(bas.register_date <= '2026-05-31', 1, 0)), 0) AS register_cnt_total, /*	历史总注册玩家数 */
      0 AS lose_cnt_7ds, /*	7日流失玩家数 */
      0 AS active_cnt_7ds, /*	7日前DAU */
      0 AS lose_cnt_30ds, /*	30日流失玩家数 */
      0 AS active_cnt_30ds, /*	30日前DAU */
      COALESCE(SUM(IF(COALESCE(act_di.is_7d, 0) = 1, 1, 0)), 0) AS active_cnt_7days, /*	近7日活跃玩家数 */
      SUM(COALESCE(year_pay_amt, 0)) AS year_pay_amt, /*	本年累计付费金额 */
      0 AS year_before_tax_usd_amt, /*	本年累计付费税率校准金额 */
      SUM(COALESCE(his_pay_amt, 0)) AS his_pay_amt, /*	历史累计付费金额 */
      0 AS his_before_tax_usd_amt, /*	历史累计税率校准付费金额 */
      0 AS recurring_cnt_14days,
      0 AS nologin_cnt_14days,
      0 AS actual_pay_amt,
      2 AS user_type,
      NULL AS channel,
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
          ) / LEAST(DATEDIFF('2026-05-31', '2019-02-28') + 1, 7),
          0
        ),
        0
      ) AS vaild_user_online_dur,
      'mla' AS appname,
      'daily' AS date_type,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM basic AS bas
    LEFT JOIN active_di AS act_di
      ON bas.roleid = act_di.roleid
    LEFT JOIN pay_di AS pay_di
      ON bas.roleid = pay_di.roleid
    GROUP BY
      COALESCE(bas.country, 'unknown')
  ) AS ads_gamebi_roger_primary_di_mid
  WHERE
    logymd = '2026-05-31' /* and logymd >= '2025-08-27' */
    AND appname = 'nova'
    AND granularity_type = 'account'
    AND date_type = 'monthly'
) AS a;
