-- all-production-sql path_id: 14
-- target_definition_id: definition.ae9c85d0b2876d6aef089ac0
-- jobs: job.100037207_0 -> job.100037162_0
-- producer choice: field.table.mt_ads.ads_gamebi_roger_primary_di_mid_timezone.active_cnt=definition.6324d6f4115bdabbdae46ac1
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.ae9c85d0b2876d6aef089ac0
-- inlined jobs: job.100037207_0 -> job.100037162_0
-- external boundary: msdk_dwm.dwm_active_role_zone_di.logymd
-- WARNING: selected producer for mt_ads.ads_gamebi_roger_primary_di_mid_timezone writes static partition date_type='daily', but downstream filters date_type='timezone'; this branch returns no rows
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
    is_acc_cur_bot
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
      COALESCE(register_cnt_total, 0) AS register_cnt_total, /*	历史总注册玩家数 */
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
      'all' AS region,
      is_acc_cur_bot AS is_acc_cur_bot,
      COALESCE(active_cnt_90days, 0) AS active_cnt_90days,
      COALESCE(vaild_user_cnt, 0) AS vaild_user_cnt,
      COALESCE(vaild_user_online_dur, 0) AS vaild_user_online_dur,
      'nova' AS appname,
      'daily' AS date_type,
      'account' AS granularity_type,
      '2026-05-31' AS logymd
    FROM (
      SELECT
        country_code AS country,
        appname
      FROM mt_dim.dim_gamebi_country
      WHERE
        logymd = (
          SELECT
            MAX(logymd)
          FROM mt_dim.dim_gamebi_country
        ) /* 取最新 */
        AND startdate <= '2026-05-31'
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
        COALESCE(is_acc_cur_bot, 0) AS is_acc_cur_bot,
        COALESCE(SUM(register_cnt_total), 0) AS register_cnt_total,
        COALESCE(SUM(active_cnt_90days), 0) AS active_cnt_90days,
        COALESCE(SUM(vaild_user_cnt), 0) AS vaild_user_cnt,
        COALESCE(SUM(vaild_user_online_dur), 0) AS vaild_user_online_dur,
        logymd,
        appname
      FROM (
        SELECT
          bd.app_id,
          ap.appname,
          COALESCE(LOWER(first_mt_country), 'unknown') AS country,
          bd.os,
          COALESCE(is_acc_cur_bot, 0) AS is_acc_cur_bot,
          COALESCE(LOWER(first_network_name), 'unknown') AS network,
          SUM(IF(createdate = '2026-05-31', 1, 0)) AS register_cnt,
          SUM(is_td) AS active_cnt,
          SUM(is_30d) AS active_cnt_30days,
          SUM(pay_cnt) AS pay_cnt, /* 付费人数 */
          SUM(day_pay_amt) AS pay_amt,
          SUM(is_7d) AS active_cnt_7days,
          SUM(total_pay_amt) AS total_pay_amt,
          SUM(year_pay_amt) AS year_pay_amt,
          COALESCE(SUM(online_time), 0) AS day_login_duration,
          COALESCE(SUM(IF(createdate <> 'unknown', 1, 0)), 0) AS register_cnt_total,
          COALESCE(SUM(IF(ad.is_90d = 1, 1, 0)), 0) AS active_cnt_90days,
          COALESCE(
            SUM(
              IF(ad.is_td = 1 AND (
                ad.active_days_7days >= 2 OR pay.pay_amt_7days > 0
              ), 1, 0)
            ),
            0
          ) AS vaild_user_cnt,
          COALESCE(
            ROUND(
              SUM(
                IF(
                  ad.is_td = 1 AND (
                    ad.active_days_7days >= 2 OR pay.pay_amt_7days > 0
                  ),
                  on_t.online_time_7days,
                  0
                )
              ) / LEAST(DATEDIFF('2026-05-31', '2025-06-25') + 1, 7),
              0
            ),
            0
          ) AS vaild_user_online_dur,
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
              first_network_name,
              createdate,
              createtime,
              ROW_NUMBER() OVER (PARTITION BY app_id, account_id ORDER BY tag ASC, createtime ASC) AS rn
            FROM (
              SELECT
                appid AS app_id,
                roleid AS account_id,
                first_mt_country,
                os,
                first_media_source AS first_network_name,
                createdate,
                createtime,
                1 AS tag
              FROM msdk_dim.dim_basic_role_zone_df
              WHERE
                logymd = '2026-05-31'
                AND logymd >= '2025-06-25'
                AND createdate >= '2025-06-25'
                AND /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     appid in (4110,4210,4300,4260) */ (
                  appid = 4400
                  AND (
                    zoneid BETWEEN 20001 AND 24999
                    OR zoneid BETWEEN 10001 AND 14999
                    OR zoneid BETWEEN 15001 AND 17999
                    OR zoneid BETWEEN 25001 AND 27999
                  )
                )
              UNION ALL
              SELECT
                app_id,
                roleid AS account_id,
                'unknown' AS first_mt_country,
                'unknown' AS os,
                'unknown' AS first_network_name,
                'unknown' AS createdate,
                'unknown' AS createtime,
                2 AS tag
              FROM msdk_dwm.dwm_active_role_zone_di
              WHERE
                logymd = '2026-05-31'
                AND logymd >= '2025-06-25'
                AND /* AND     (zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260)) */ (
                  app_id = 4400
                  AND (
                    zoneid BETWEEN 20001 AND 24999
                    OR zoneid BETWEEN 10001 AND 14999
                    OR zoneid BETWEEN 15001 AND 17999
                    OR zoneid BETWEEN 25001 AND 27999
                  )
                )
            )
          )
          WHERE
            rn = 1
        ) AS bd
        LEFT JOIN (
          SELECT
            a.roleid,
            IF(NOT b.roleid IS NULL, 0, COALESCE(is_acc_cur_bot, 0)) AS is_acc_cur_bot
          FROM (
            SELECT
              roleid,
              MAX(is_acc_cur_bot) AS is_acc_cur_bot
            FROM mt_dim.dim_basic_role_zone_df_timezone
            WHERE
              logymd = '2026-05-31'
              AND logymd >= '2025-06-25'
              AND createdate >= '2025-06-25'
              AND region IN ('all')
            GROUP BY
              roleid
          ) AS a
          LEFT JOIN (
            SELECT
              roleid,
              SUM(total_pay_amt) AS total_pay_amt
            FROM msdk_dwm.dwm_pay_role_zone_df
            WHERE
              logymd = '2026-05-31'
              AND logymd >= '2025-06-25'
              AND /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260) */ (
                app_id = 4400
                AND (
                  zoneid BETWEEN 20001 AND 24999
                  OR zoneid BETWEEN 10001 AND 14999
                  OR zoneid BETWEEN 15001 AND 17999
                  OR zoneid BETWEEN 25001 AND 27999
                )
              )
            GROUP BY
              roleid
            HAVING
              SUM(total_pay_amt) > 0
          ) AS b
            ON a.roleid = b.roleid
        ) AS bot_info
          ON bot_info.roleid = bd.account_id
        LEFT JOIN (
          SELECT
            roleid AS account_id,
            app_id,
            MAX(IF(logymd = '2026-05-31', 1, 0)) AS is_td,
            MAX(IF(logymd BETWEEN '2026-05-02' AND '2026-05-31', 1, 0)) AS is_30d,
            MAX(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', 1, 0)) AS is_7d,
            MAX(IF(logymd BETWEEN '2026-03-03' AND '2026-05-31', 1, 0)) AS is_90d, /* SUM(IF(logymd = '2026-05-31', online_time, 0)) AS day_login_duration */ /* 近90天是否活跃 */
            COUNT(DISTINCT IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', logymd, NULL)) AS active_days_7days /* 近7日活跃天数 */
          FROM msdk_dwm.dwm_active_role_zone_di
          WHERE
            logymd <= '2026-05-31'
            AND logymd >= '2026-03-03'
            AND logymd >= '2025-06-25'
            AND /* AND     (zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260)) */ (
              app_id = 4400
              AND (
                zoneid BETWEEN 20001 AND 24999
                OR zoneid BETWEEN 10001 AND 14999
                OR zoneid BETWEEN 15001 AND 17999
                OR zoneid BETWEEN 25001 AND 27999
              )
            )
          GROUP BY
            roleid,
            app_id
        ) AS ad
          ON ad.app_id = bd.app_id AND ad.account_id = bd.account_id
        LEFT JOIN (
          SELECT
            roleid AS account_id,
            app_id,
            COUNT(DISTINCT IF(logymd = '2026-05-31', CONCAT_WS(',', app_id, roleid), NULL)) AS pay_cnt,
            SUM(IF(logymd = '2026-05-31', day_pay_sum, 0)) AS day_pay_amt,
            SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', day_pay_sum, 0)) AS pay_amt_7days
          FROM msdk_dwm.dwm_pay_role_zone_di
          WHERE
            logymd <= '2026-05-31'
            AND logymd >= '2026-05-25'
            AND /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260) */ (
              app_id = 4400
              AND (
                zoneid BETWEEN 20001 AND 24999
                OR zoneid BETWEEN 10001 AND 14999
                OR zoneid BETWEEN 15001 AND 17999
                OR zoneid BETWEEN 25001 AND 27999
              )
            )
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
          FROM msdk_dwm.dwm_pay_role_zone_di
          WHERE
            logymd <= '2026-05-31'
            AND logymd >= '2025-06-25'
            AND /* AND     zoneid NOT BETWEEN 9900 AND 9999 */ /* AND     zoneid NOT BETWEEN 29000 AND 29999 */ /* AND     app_id in (4110,4210,4300,4260) */ (
              app_id = 4400
              AND (
                zoneid BETWEEN 20001 AND 24999
                OR zoneid BETWEEN 10001 AND 14999
                OR zoneid BETWEEN 15001 AND 17999
                OR zoneid BETWEEN 25001 AND 27999
              )
            )
          GROUP BY
            roleid,
            app_id
        ) AS pay_total
          ON bd.app_id = pay_total.app_id AND bd.account_id = pay_total.account_id
        LEFT JOIN (
          SELECT
            app_id,
            roleid,
            SUM(IF(logymd = '2026-05-31', online_time, 0)) AS online_time,
            SUM(IF(logymd BETWEEN '2026-05-25' AND '2026-05-31', online_time, 0)) AS online_time_7days
          FROM (
            SELECT
              app_id,
              role_id AS roleid,
              logymd,
              SUM(
                IF(
                  GET_JSON_OBJECT(`event_desc`, '$.online_time') >= 21600,
                  21600,
                  GET_JSON_OBJECT(`event_desc`, '$.online_time')
                )
              ) AS online_time
            FROM msdk_dwd.dwd_event_log_detail_di
            WHERE
              logymd <= '2026-05-31'
              AND logymd >= '2026-05-25'
              AND logymd >= '2025-06-25'
              AND (
                app_id = 4400
                AND (
                  zone_id BETWEEN 20001 AND 24999
                  OR zone_id BETWEEN 10001 AND 14999
                  OR zone_id BETWEEN 15001 AND 17999
                  OR zone_id BETWEEN 25001 AND 27999
                )
              )
              AND event = 'logout'
            GROUP BY
              role_id,
              app_id,
              logymd
          )
          GROUP BY
            app_id,
            roleid
        ) AS on_t
          ON bd.app_id = on_t.app_id AND bd.account_id = on_t.roleid
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
          COALESCE(LOWER(first_mt_country), 'unknown'),
          bd.os,
          COALESCE(LOWER(first_network_name), 'unknown'),
          COALESCE(is_acc_cur_bot, 0)
      )
      GROUP BY
        COALESCE(country, 'unknown'),
        COALESCE(os, 'unknown'),
        COALESCE(network, 'unknown'),
        logymd,
        appname,
        COALESCE(is_acc_cur_bot, 0)
    ) AS b
      ON a.country = b.country AND a.appname = b.appname
  ) AS ads_gamebi_roger_primary_di_mid_timezone
  WHERE
    logymd = '2026-05-31'
    AND logymd >= '2025-06-25'
    AND appname = 'nova'
    AND granularity_type = 'account'
    AND date_type = 'timezone'
    AND region = 'apac'
) AS a;
