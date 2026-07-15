-- all-production-sql path_id: 98
-- target_definition_id: definition.472b6d36ff96ab4e391e8842
-- jobs: job.100001123_0 -> job.100032988_0 -> job.100025287_0
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid.__rows__=definition.2c6ecace7f6a3d2eae83ae95
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid.active_cnt=definition.a98768ce384e26f101a91189
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.472b6d36ff96ab4e391e8842
-- inlined jobs: job.100001123_0 -> job.100032988_0 -> job.100025287_0
-- external boundary: mt_dwm.dwm_mla_active_role_zone_di.logymd
-- external boundary: mt_dim.dim_mla_basic_role_zone_df.*
-- external boundary: mt_dwm.dwm_mla_active_role_zone_di.*
-- external boundary: mh_ods.gameserver_charge.*
-- external boundary: mt_dim.dim_mla_product_type_df.*
-- external boundary: mt_ads.ads_gamebi_create_reten_ltv_df.*
-- external boundary: mt_ads.ads_gamebi_active_reten_di.*
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition date_type='daily', but downstream filters date_type='monthly'; this branch returns no rows
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid writes static partition appname='mla', but downstream filters appname='mlbb'; this branch returns no rows
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
  FROM (
    SELECT
      roleid,
      zoneid,
      MIN(day_first_pay_time) AS day_first_pay_time,
      MAX(day_last_pay_time) AS day_last_pay_time,
      SUM(charge_cnt) AS charge_cnt,
      SUM(charge_money) AS charge_money,
      STR_TO_MAP(CONCAT_WS(',', COLLECT_SET(CONCAT_WS(':', product_type_1, charge_money))), ',', ':') AS product_type_amt_map,
      'mla' AS appid,
      '2026-05-31' AS logymd
    FROM (
      SELECT
        roleid,
        zoneid,
        IF(product_type = '' OR product_type IS NULL, 'unknown', product_type) AS product_type_1, /* '其他'大类,代表一种付费类型，保留 */
        MIN(`time`) AS day_first_pay_time,
        MAX(`time`) AS day_last_pay_time,
        COUNT(1) AS charge_cnt,
        SUM(money) AS charge_money
      FROM charge
      GROUP BY
        roleid,
        zoneid,
        product_type_1
    )
    GROUP BY
      roleid,
      zoneid
  ) AS dwm_mla_pay_role_zone_di
  WHERE
    logymd <= '2026-05-31' AND logymd >= '2019-02-28' /* 限制上线日期 */
  GROUP BY
    roleid
), charge AS (
  SELECT
    chg.roleid,
    chg.zoneid,
    chg.`time`,
    chg.`money`,
    IF('2026-05-31' <= '2022-04-30', pro.product_type, chg.product_type) AS product_type
  FROM (
    SELECT
      *
    FROM mh_ods.gameserver_charge
    WHERE
      logymd = '2026-05-31' AND `money` > 0
  ) AS chg
  LEFT JOIN (
    SELECT DISTINCT
      product_id,
      product_subid,
      product_name,
      product_type
    FROM mt_dim.dim_mla_product_type_df
    WHERE
      logymd = (
        SELECT
          MAX(logymd)
        FROM mt_dim.dim_mla_product_type_df
      )
  ) AS pro
    ON chg.product_id = pro.product_id AND chg.product_subid = pro.product_subid
)
SELECT
  active_cnt /*	活跃玩家数 */
FROM (
  SELECT
    date_range,
    LAST_DAY(CONCAT(date_range, '-01')) AS logymd,
    COALESCE(country, 'unknown') AS country,
    COALESCE(os, 'unknown') AS os,
    COALESCE(network, 'unknown') AS network,
    COALESCE(SUM(register_cnt), 0) AS register_cnt,
    COALESCE(SUM(pure_register_cnt), 0) AS pure_register_cnt,
    COALESCE(SUM(active_cnt), 0) AS active_cnt,
    COALESCE(SUM(active_cnt_30days), 0) AS active_cnt_30days,
    COALESCE(SUM(pay_cnt), 0) AS pay_cnt,
    COALESCE(SUM(pay_amt), 0) AS pay_amt,
    COALESCE(SUM(active_pay_30d_cnt), 0) AS active_pay_30d_cnt,
    COALESCE(SUM(active_register_pay_30d_cnt), 0) AS active_register_pay_30d_cnt,
    COALESCE(SUM(active_register_30d_cnt), 0) AS active_register_30d_cnt,
    COALESCE(SUM(recurring_cnt_30days), 0) AS recurring_cnt_30days,
    COALESCE(SUM(nologin_cnt_30days), 0) AS nologin_cnt_30days,
    COALESCE(ARRAY_MERGE(register_reten_cnt), ARRAY(0, 0, 0, 0, 0, 0)) AS register_reten_cnt,
    COALESCE(ARRAY_MERGE(recurring_reten_cnt), ARRAY(0, 0, 0, 0, 0, 0)) AS recurring_reten_cnt,
    COALESCE(SUM(pay_amt_exrate), 0) AS pay_amt_exrate,
    COALESCE(ARRAY_MERGE(pure_reten_cnt), ARRAY(0, 0, 0, 0, 0, 0)) AS pure_reten_cnt,
    COALESCE(ARRAY_MERGE(old_reten_cnt), ARRAY(0, 0, 0, 0, 0, 0)) AS old_reten_cnt,
    COALESCE(SUM(active_cnt_period), 0) AS active_cnt_period,
    COALESCE(SUM(pay_cnt_period), 0) AS pay_cnt_period,
    COALESCE(SUM(online_dur), 0) AS online_dur,
    COALESCE(SUM(new_active_cnt), 0) AS new_active_cnt,
    COALESCE(SUM(lose_cnt_7ds), 0) AS lose_cnt_7ds,
    COALESCE(SUM(active_cnt_7ds), 0) AS active_cnt_7ds,
    COALESCE(SUM(lose_cnt_30ds), 0) AS lose_cnt_30ds,
    COALESCE(SUM(active_cnt_30ds), 0) AS active_cnt_30ds,
    COALESCE(SUM(active_cnt_7days), 0) AS active_cnt_7days,
    COALESCE(SUM(recurring_cnt_14days), 0) AS recurring_cnt_14days,
    COALESCE(SUM(nologin_cnt_14days), 0) AS nologin_cnt_14days,
    COALESCE(ARRAY_MERGE(recurring_14days_reten_cnt), ARRAY(0, 0, 0, 0, 0, 0)) AS recurring_14days_reten_cnt,
    COALESCE(SUM(actual_pay_amt), 0) AS actual_pay_amt
  FROM (
    SELECT
      date_range,
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
      ARRAY(0, 0, 0, 0, 0, 0) AS register_reten_cnt,
      ARRAY(0, 0, 0, 0, 0, 0) AS recurring_reten_cnt,
      pay_amt_exrate,
      ARRAY(0, 0, 0, 0, 0, 0) AS pure_reten_cnt,
      ARRAY(0, 0, 0, 0, 0, 0) AS old_reten_cnt,
      active_cnt_period,
      pay_cnt_period,
      online_dur,
      new_active_cnt,
      lose_cnt_7ds,
      active_cnt_7ds,
      lose_cnt_30ds,
      active_cnt_30ds,
      active_cnt_7days,
      recurring_cnt_14days,
      nologin_cnt_14days,
      ARRAY(0, 0, 0, 0, 0, 0) AS recurring_14days_reten_cnt,
      actual_pay_amt
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
      IF(
        SUBSTRING(DATE_ADD('2026-05-31', 1), 9, 2) = '01',
        logymd BETWEEN SUBSTRING(DATE_TRUNC('MONTH', ADD_MONTHS('2026-05-31', -1)), 1, 10) AND LAST_DAY(ADD_MONTHS('2026-05-31', 0)),
        logymd BETWEEN SUBSTRING(DATE_TRUNC('MONTH', ADD_MONTHS('2026-05-31', -2)), 1, 10) AND LAST_DAY(ADD_MONTHS('2026-05-31', -1))
      )
      AND appname = 'mlbb'
      AND granularity_type = 'account'
      AND date_type = 'monthly'
    UNION ALL
    SELECT
      SUBSTRING(register_date, 1, 7) AS date_range,
      country,
      os,
      network,
      0 AS register_cnt,
      0 AS pure_register_cnt,
      0 AS active_cnt,
      0 AS active_cnt_30days,
      0 AS pay_cnt,
      0 AS pay_amt,
      0 AS active_pay_30d_cnt,
      0 AS active_register_pay_30d_cnt,
      0 AS active_register_30d_cnt,
      0 AS recurring_cnt_30days,
      0 AS nologin_cnt_30days,
      ARRAY(reten_cnt[0], reten_cnt[1], reten_cnt[2], reten_cnt[6], reten_cnt[13], reten_cnt[29]) AS register_reten_cnt,
      ARRAY(0, 0, 0, 0, 0, 0) AS recurring_reten_cnt,
      0 AS pay_amt_exrate,
      IF(
        new_type = 3,
        ARRAY(reten_cnt[0], reten_cnt[1], reten_cnt[2], reten_cnt[6], reten_cnt[13], reten_cnt[29]),
        ARRAY(0, 0, 0, 0, 0, 0)
      ) AS pure_reten_cnt,
      ARRAY(0, 0, 0, 0, 0, 0) AS old_reten_cnt,
      0 AS active_cnt_period,
      0 AS pay_cnt_period,
      0 AS online_dur,
      0 AS new_active_cnt,
      0 AS lose_cnt_7ds,
      0 AS active_cnt_7ds,
      0 AS lose_cnt_30ds,
      0 AS active_cnt_30ds,
      0 AS active_cnt_7days,
      0 AS recurring_cnt_14days,
      0 AS nologin_cnt_14days,
      ARRAY(0, 0, 0, 0, 0, 0) AS recurring_14days_reten_cnt,
      0 AS actual_pay_amt
    FROM mt_ads.ads_gamebi_create_reten_ltv_df
    WHERE
      logymd = '2026-05-31'
      AND /* 获取两个月的月度数据 */ IF(
        SUBSTRING(DATE_ADD('2026-05-31', 1), 9, 2) = '01',
        register_date BETWEEN SUBSTRING(DATE_TRUNC('MONTH', ADD_MONTHS('2026-05-31', -1)), 1, 10) AND LAST_DAY(ADD_MONTHS('2026-05-31', 0)),
        register_date BETWEEN SUBSTRING(DATE_TRUNC('MONTH', ADD_MONTHS('2026-05-31', -2)), 1, 10) AND LAST_DAY(ADD_MONTHS('2026-05-31', -1))
      )
      AND granularity_type = 'account57'
    UNION ALL
    SELECT
      SUBSTRING(logymd, 1, 7) AS date_range,
      country,
      os,
      network,
      0 AS register_cnt,
      0 AS pure_register_cnt,
      0 AS active_cnt,
      0 AS active_cnt_30days,
      0 AS pay_cnt,
      0 AS pay_amt,
      0 AS active_pay_30d_cnt,
      0 AS active_register_pay_30d_cnt,
      0 AS active_register_30d_cnt,
      0 AS recurring_cnt_30days,
      0 AS nologin_cnt_30days,
      ARRAY(0, 0, 0, 0, 0, 0) AS register_reten_cnt,
      ARRAY(
        recurring_reten_cnt[0],
        recurring_reten_cnt[1],
        recurring_reten_cnt[2],
        recurring_reten_cnt[6],
        recurring_reten_cnt[13],
        recurring_reten_cnt[29]
      ) AS recurring_reten_cnt,
      0 AS pay_amt_exrate,
      ARRAY(0, 0, 0, 0, 0, 0) AS pure_reten_cnt,
      ARRAY(
        old_reten_cnt[0],
        old_reten_cnt[1],
        old_reten_cnt[2],
        old_reten_cnt[6],
        old_reten_cnt[13],
        old_reten_cnt[29]
      ) AS old_reten_cnt,
      0 AS active_cnt_period,
      0 AS pay_cnt_period,
      0 AS online_dur,
      0 AS new_active_cnt,
      0 AS lose_cnt_7ds,
      0 AS active_cnt_7ds,
      0 AS lose_cnt_30ds,
      0 AS active_cnt_30ds,
      0 AS active_cnt_7days,
      0 AS recurring_cnt_14days,
      0 AS nologin_cnt_14days,
      ARRAY(
        recurring_14days_reten_cnt[0],
        recurring_14days_reten_cnt[1],
        recurring_14days_reten_cnt[2],
        recurring_14days_reten_cnt[6],
        recurring_14days_reten_cnt[13],
        recurring_14days_reten_cnt[29]
      ) AS recurring_14days_reten_cnt,
      0 AS actual_pay_amt
    FROM mt_ads.ads_gamebi_active_reten_di
    WHERE
      IF(
        SUBSTRING(DATE_ADD('2026-05-31', 1), 9, 2) = '01',
        logymd BETWEEN SUBSTRING(DATE_TRUNC('MONTH', ADD_MONTHS('2026-05-31', -1)), 1, 10) AND LAST_DAY(ADD_MONTHS('2026-05-31', 0)),
        logymd BETWEEN SUBSTRING(DATE_TRUNC('MONTH', ADD_MONTHS('2026-05-31', -2)), 1, 10) AND LAST_DAY(ADD_MONTHS('2026-05-31', -1))
      )
      AND granularity_type = 'account57'
  )
  GROUP BY
    date_range,
    LAST_DAY(CONCAT(date_range, '-01')),
    COALESCE(country, 'unknown'),
    COALESCE(os, 'unknown'),
    COALESCE(network, 'unknown')
);
