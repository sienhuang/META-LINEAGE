-- all-production-sql path_id: 6
-- target_definition_id: definition.5161b506a99bfdb821541531
-- jobs: job.100037150_0 -> job.100031072_0
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt=definition.2f84b47862016d1324f251c6
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.5161b506a99bfdb821541531
-- inlined jobs: job.100037150_0 -> job.100031072_0
-- external boundary: mt_dwm.dwm_active_role_zone_di_timezone.logymd
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid_timezone writes static partition date_type='timezone', but downstream filters date_type='daily'; this branch returns no rows
SELECT
  COALESCE(active_cnt, 0) AS active_cnt
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
    logymd,
    is_acc_cur_bot,
    active_cnt_90days,
    vaild_user_cnt,
    vaild_user_online_dur
  FROM (
    SELECT
      '2026-05-31' AS date_range,
      COALESCE(a.country, b.country) AS country,
      COALESCE(b.os, 'NULL') AS os,
      COALESCE(b.network, 'NULL') AS network,
      COALESCE(register_cnt, 0) AS register_cnt,
      0 AS pure_register_cnt,
      COALESCE(active_cnt, 0) AS active_cnt,
      COALESCE(active_cnt_30days, 0) AS active_cnt_30days,
      COALESCE(pay_cnt, 0) AS pay_cnt,
      COALESCE(pay_amt, 0) AS pay_amt,
      0 AS active_pay_30d_cnt,
      0 AS active_register_pay_30d_cnt,
      0 AS active_register_30d_cnt,
      0 AS recurring_cnt_30days,
      0 AS nologin_cnt_30days,
      0 AS pay_amt_exrate,
      COALESCE(active_cnt, 0) AS active_cnt_period,
      COALESCE(pay_cnt, 0) AS pay_cnt_period,
      COALESCE(day_login_duration, 0) AS online_dur, /*	当日玩家总在线时长(单位：s) */
      0 AS new_active_cnt, /*	新用户活跃玩家数 */
      0 AS register_cnt_total, /*	历史总注册玩家数 */
      0 AS lose_cnt_7ds, /*	7日流失玩家数 */
      0 AS active_cnt_7ds, /*	7日前DAU */
      0 AS lose_cnt_30ds, /*	30日流失玩家数 */
      0 AS active_cnt_30ds, /*	30日前DAU */
      COALESCE(active_cnt_7days, 0) AS active_cnt_7days,
      COALESCE(year_pay_amt, 0) AS year_pay_amt,
      0 AS year_before_tax_usd_amt,
      COALESCE(total_pay_amt, 0) AS his_pay_amt,
      0 AS his_before_tax_usd_amt,
      0 AS recurring_cnt_14days,
      0 AS nologin_cnt_14days,
      0 AS actual_pay_amt,
      region,
      is_acc_cur_bot,
      0 AS active_cnt_90days,
      0 AS vaild_user_cnt,
      0 AS vaild_user_online_dur,
      'nova' AS appname,
      'timezone' AS date_type,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM (
      SELECT
        country_code AS country,
        appname
      FROM mt_dim.dim_decismart_app_zone_country_df
      WHERE
        logymd = (
          SELECT
            MAX(logymd)
          FROM mt_dim.dim_decismart_app_zone_country_df
        ) /* 取最新 */
        AND appname = 'nova'
        AND is_online = 1
        AND definition_type = 0
      GROUP BY
        country_code,
        appname
    ) AS a
    LEFT JOIN (
      SELECT
        COALESCE(country, 'unknown') AS country,
        COALESCE(os, 'unknown') AS os,
        COALESCE(network, 'unknown') AS network,
        COALESCE(region, 'unknown') AS region,
        COALESCE(is_acc_cur_bot, 0) AS is_acc_cur_bot,
        COALESCE(SUM(register_cnt), 0) AS register_cnt,
        0 AS pure_register_cnt,
        COALESCE(SUM(active_cnt), 0) AS active_cnt,
        COALESCE(SUM(active_cnt_30days), 0) AS active_cnt_30days,
        COALESCE(SUM(pay_cnt), 0) AS pay_cnt,
        COALESCE(SUM(pay_amt), 0) AS pay_amt,
        0 AS pay_amt_exrate,
        COALESCE(SUM(active_cnt_7days), 0) AS active_cnt_7days,
        COALESCE(SUM(total_pay_amt), 0) AS total_pay_amt,
        COALESCE(SUM(year_pay_amt), 0) AS year_pay_amt,
        COALESCE(SUM(day_login_duration), 0) AS day_login_duration,
        logymd,
        appname
      FROM (
        SELECT
          bd.app_id,
          ap.appname,
          COALESCE(LOWER(first_mt_country), 'unknown') AS country,
          COALESCE(bd.os, 'unknown') AS os,
          COALESCE(region, 'unknown') AS region,
          COALESCE(is_acc_cur_bot, 0) AS is_acc_cur_bot,
          COALESCE(LOWER(first_network_name), 'unknown') AS network,
          SUM(IF(createdate = '2026-05-31', 1, 0)) AS register_cnt,
          SUM(is_td) AS active_cnt,
          SUM(is_30d) AS active_cnt_30days,
          COUNT(DISTINCT pay.app_id, pay.account_id) AS pay_cnt, /* 付费人数 */
          SUM(day_pay_amt) AS pay_amt,
          SUM(is_7d) AS active_cnt_7days,
          SUM(total_pay_amt) AS total_pay_amt,
          SUM(year_pay_amt) AS year_pay_amt,
          0 AS day_login_duration, /* NVL(SUM(online_time), 0) AS day_login_duration, */
          '2026-05-31' AS logymd
        FROM (
          SELECT
            *
          FROM (
            SELECT
              app_id,
              account_id,
              first_mt_country,
              os,
              region,
              first_network_name,
              createdate,
              createtime,
              is_acc_cur_bot,
              ROW_NUMBER() OVER (PARTITION BY app_id, account_id ORDER BY tag ASC, createtime ASC) AS rn
            FROM (
              SELECT
                app_id AS app_id,
                roleid AS account_id,
                createrole_country AS first_mt_country,
                os,
                'unknown' AS first_network_name,
                createdate,
                createtime,
                region,
                is_acc_cur_bot,
                1 AS tag /* FROM    msdk_dim.dim_basic_role_zone_df */
              FROM mt_dim.dim_basic_role_zone_df_timezone
              WHERE
                logymd = '2026-05-31'
                AND logymd >= '2025-06-25'
                AND createdate >= '2025-06-25'
                AND region IN ('apac') /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     appid in (4110,4210,4300,4260) */ /* AND     ( */ /*             appid = 4400 */ /*             AND ( */ /*                 zoneid BETWEEN 20001 AND 24999 */ /*                 OR zoneid BETWEEN 10001 AND 14999 */ /*                 OR zoneid BETWEEN 15001 AND 17999 */ /*                 OR zoneid BETWEEN 25001 AND 27999 */ /*             ) */ /*         ) */
              UNION ALL
              SELECT
                app_id,
                roleid AS account_id,
                day_first_createrole_country AS first_mt_country,
                day_first_os AS os,
                'unknown' AS first_network_name,
                'unknown' AS createdate,
                'unknown' AS createtime,
                region,
                0 AS is_acc_cur_bot,
                2 AS tag /* FROM    msdk_dwm.dwm_active_role_zone_di */
              FROM mt_dwm.dwm_active_role_zone_di_timezone
              WHERE
                logymd = '2026-05-31'
                AND logymd >= '2025-06-25'
                AND region IN ('apac') /* AND     (zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /*         -- AND     app_id in (4110,4210,4300,4260)) */ /* AND     ( */ /*             app_id = 4400 */ /*             AND ( */ /*                 zoneid BETWEEN 20001 AND 24999 */ /*                 OR zoneid BETWEEN 10001 AND 14999 */ /*                 OR zoneid BETWEEN 15001 AND 17999 */ /*                 OR zoneid BETWEEN 25001 AND 27999 */ /*             ) */ /*         ) */
              UNION ALL
              SELECT
                app_id,
                roleid AS account_id,
                day_first_createrole_country AS first_mt_country,
                day_first_os AS os,
                'unknown' AS first_network_name,
                'unknown' AS createdate,
                'unknown' AS createtime,
                region,
                0 AS is_acc_cur_bot,
                3 AS tag /* FROM    msdk_dwm.dwm_active_role_zone_di */
              FROM mt_dwm.dwm_pay_role_zone_di_timezone
              WHERE
                logymd = '2026-05-31'
                AND logymd >= '2025-06-25'
                AND app_id = 4400
                AND region IN ('apac')
            )
          )
          WHERE
            rn = 1
        ) AS bd
        LEFT JOIN (
          SELECT
            roleid AS account_id,
            app_id,
            MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
            MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_30d,
            MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_7d /* SUM(IF(logymd = '2026-05-31', online_time, 0)) AS day_login_duration */
          FROM mt_dwm.dwm_active_role_zone_di_timezone
          WHERE
            logymd <= '2026-05-31'
            AND logymd >= '2026-05-02'
            AND logymd >= '2025-06-25'
            AND region IN ('apac') /* AND     (zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260)) */ /* AND     ( */ /*             app_id = 4400 */ /*             AND ( */ /*                 zoneid BETWEEN 20001 AND 24999 */ /*                 OR zoneid BETWEEN 10001 AND 14999 */ /*                 OR zoneid BETWEEN 15001 AND 17999 */ /*                 OR zoneid BETWEEN 25001 AND 27999 */ /*             ) */ /*         ) */
          GROUP BY
            roleid,
            app_id
        ) AS ad
          ON ad.app_id = bd.app_id AND ad.account_id = bd.account_id
        LEFT JOIN (
          SELECT
            roleid AS account_id,
            app_id,
            SUM(day_pay_sum) AS day_pay_amt /* FROM    msdk_dwm.dwm_pay_role_zone_di */
          FROM mt_dwm.dwm_pay_role_zone_di_timezone
          WHERE
            logymd = '2026-05-31'
            AND logymd >= '2025-06-25'
            AND app_id = 4400
            AND region IN ('apac') /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260) */ /* AND     ( */ /*             app_id = 4400 */ /*             AND ( */ /*                 zoneid BETWEEN 20001 AND 24999 */ /*                 OR zoneid BETWEEN 10001 AND 14999 */ /*                 OR zoneid BETWEEN 15001 AND 17999 */ /*                 OR zoneid BETWEEN 25001 AND 27999 */ /*             ) */ /*         ) */
          GROUP BY
            roleid,
            app_id
        ) AS pay
          ON bd.app_id = pay.app_id AND bd.account_id = pay.account_id
        LEFT JOIN (
          SELECT
            roleid AS account_id,
            app_id,
            SUM(day_pay_sum) AS total_pay_amt,
            SUM(
              IF(
                logymd <= '2026-05-31'
                AND logymd >= CONCAT(SUBSTRING('2026-05-31', 1, 4), '-01-01'),
                COALESCE(day_pay_sum, 0),
                0
              )
            ) AS year_pay_amt
          FROM mt_dwm.dwm_pay_role_zone_di_timezone
          WHERE
            logymd <= '2026-05-31'
            AND logymd >= '2025-06-25'
            AND app_id = 4400
            AND region IN ('apac') /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260) */ /* AND     ( */ /*             app_id = 4400 */ /*             AND ( */ /*                 zoneid BETWEEN 20001 AND 24999 */ /*                 OR zoneid BETWEEN 10001 AND 14999 */ /*                 OR zoneid BETWEEN 15001 AND 17999 */ /*                 OR zoneid BETWEEN 25001 AND 27999 */ /*             ) */ /*         ) */
          GROUP BY
            roleid,
            app_id
        ) AS pay_total
          ON bd.app_id = pay_total.app_id
          AND bd.account_id = pay_total.account_id /* LEFT JOIN */ /*         ( */ /*             SELECT  app_id, */ /*                     role_id AS roleid, */ /*                     SUM( */ /*                         IF( */ /*                             get_json_object(`event_desc`, '$.online_time') >= 21600, */ /*                             21600, */ /*                             get_json_object(`event_desc`, '$.online_time') */ /*                         ) */ /*                     ) AS online_time */ /*             FROM    msdk_dwd.dwd_event_log_detail_di */ /*             WHERE   logymd = '2026-05-31' */ /*             AND     logymd >= '2025-06-25' */ /*             AND     ( */ /*                         app_id = 4400 */ /*                         AND ( */ /*                             zone_id BETWEEN 20001 AND 24999 */ /*                             OR zone_id BETWEEN 10001 AND 14999 */ /*                             OR zone_id BETWEEN 15001 AND 17999 */ /*                             OR zone_id BETWEEN 25001 AND 27999 */ /*                         ) */ /*                     ) */ /*             AND     event = 'logout' */ /*             GROUP BY */ /*                     role_id, */ /*                     app_id */ /*         ) AS on_t */ /* ON      bd.app_id = on_t.app_id */ /* AND     bd.account_id = on_t.roleid */
        JOIN (
          SELECT DISTINCT
            LOWER(appname) AS appname,
            stagename,
            stageid AS app_id
          FROM msdk_dim.dim_app_info
          WHERE
            logymd = IF('20260531' <= '20250106', '20250106', '20260531')
            AND is_online = 1
            AND LOWER(appname) = 'nova'
        ) AS ap
          ON ap.app_id = bd.app_id
        GROUP BY
          bd.app_id,
          ap.appname,
          COALESCE(region, 'unknown'),
          COALESCE(is_acc_cur_bot, 0),
          COALESCE(LOWER(first_mt_country), 'unknown'),
          COALESCE(bd.os, 'unknown'),
          COALESCE(LOWER(first_network_name), 'unknown')
      )
      GROUP BY
        COALESCE(country, 'unknown'),
        COALESCE(os, 'unknown'),
        COALESCE(network, 'unknown'),
        COALESCE(is_acc_cur_bot, 0),
        COALESCE(region, 'unknown'),
        logymd,
        appname
    ) AS b
      ON a.country = b.country AND a.appname = b.appname
  ) AS ads_gamebi_roger_primary_di_mid_timezone
  WHERE
    logymd = '2026-05-31'
    AND logymd >= '2025-06-25'
    AND appname = 'nova'
    AND granularity_type = 'account'
    AND date_type = 'daily'
) AS a;
