-- all-production-sql path_id: 4
-- target_definition_id: definition.64e2351083088a7ff6773b5f
-- jobs: job.100052167_0
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.64e2351083088a7ff6773b5f
-- inlined jobs: job.100052167_0
WITH t_create /* AND  zoneid BETWEEN 0 AND 999999 */ AS (
  SELECT
    roleid AS roleid,
    TIME AS server_time,
    zoneid AS zoneid,
    logymd,
    LOWER(COALESCE(CAST(createrole_country AS STRING), 'unknown')) AS country,
    LOWER(channel) AS channel
  FROM aoz_ods.create_role
  WHERE
    logymd <= '2026-05-31'
    AND logymd >= '2026-04-21'
    AND (
      zoneid < 19000 OR zoneid > 19999
    )
), t_login AS (
  SELECT
    roleid,
    tag,
    channel,
    logymd,
    country,
    targe_num,
    rn
  FROM (
    SELECT
      roleid AS roleid,
      'login' AS tag,
      LOWER(channel) AS channel,
      logymd,
      LOWER(COALESCE(CAST(createrole_country AS STRING), 'unknown')) AS country,
      0 AS targe_num,
      ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY TIME) AS rn
    FROM aoz_ods.login
    WHERE
      logymd = '2026-05-31'
      AND logymd >= '2026-04-21'
      AND (
        zoneid < 19000 OR zoneid > 19999
      )
  ) AS t
  WHERE
    rn = 1 AND logymd = '2026-05-31'
), t_logout_agg AS (
  SELECT
    roleid AS roleid,
    logymd,
    SUM(online_time) AS tag_num
  FROM aoz_ods.logout
  WHERE
    logymd = '2026-05-31'
    AND logymd >= '2026-04-21'
    AND (
      zoneid < 19000 OR zoneid > 19999
    ) /* AND  zoneid BETWEEN 0 AND 999999 */
  GROUP BY
    roleid,
    logymd
), t_charge AS (
  SELECT
    roleid AS roleid,
    'charge' AS tag,
    logymd,
    LOWER(channel) AS channel,
    LOWER(COALESCE(CAST(createrole_country AS STRING), 'unknown')) AS country,
    SUM(money) AS tag_num
  FROM aoz_ods.charge
  WHERE
    logymd = '2026-05-31'
    AND logymd >= '2026-04-21'
    AND (
      zoneid < 19000 OR zoneid > 19999
    ) /* AND  zoneid BETWEEN 0 AND 999999 */
  GROUP BY
    roleid,
    logymd,
    LOWER(COALESCE(CAST(createrole_country AS STRING), 'unknown')),
    LOWER(channel)
), t_logout AS (
  SELECT
    t_logout_agg.roleid,
    'logout' AS tag,
    t_login.channel,
    t_logout_agg.logymd,
    t_login.country,
    t_logout_agg.tag_num
  FROM t_logout_agg
  JOIN t_login
    ON t_logout_agg.logymd = t_login.logymd AND t_logout_agg.roleid = t_login.roleid
), indicator_role AS (
  SELECT
    roleid,
    tag,
    logymd,
    COALESCE(country, 'unknown') AS country,
    channel,
    tag_num
  FROM (
    SELECT
      roleid,
      'create' AS tag,
      channel,
      logymd,
      country,
      0 AS tag_num
    FROM (
      SELECT
        roleid,
        channel,
        logymd,
        country,
        ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY server_time) AS rn
      FROM t_create
    ) AS t
    WHERE
      rn = 1
    UNION ALL
    SELECT
      roleid,
      tag,
      channel,
      logymd,
      country,
      targe_num AS tag_num
    FROM t_login
    UNION ALL
    SELECT
      roleid,
      tag,
      channel,
      logymd,
      country,
      tag_num
    FROM t_logout
    UNION ALL
    SELECT
      roleid,
      tag,
      channel,
      logymd,
      country,
      tag_num
    FROM t_charge
  ) AS t
), t_dim AS (
  SELECT
    country_code AS country,
    'aoz' AS appname
  FROM mt_dim.dim_gamebi_country
  WHERE
    logymd = (
      SELECT
        MAX(logymd)
      FROM mt_dim.dim_gamebi_country
      WHERE
        logymd >= DATE_ADD('2026-05-31', -7)
    )
    AND startdate <= '2026-05-31'
    AND appname = 'nova'
    AND is_online = 1
    AND definition_type = 0
  GROUP BY
    country_code,
    appname
)
SELECT
  COALESCE(t3.active_cnt, 0) AS active_cnt
FROM t_dim AS t0
LEFT JOIN (
  SELECT
    COALESCE(country, 'unknown') AS country,
    CASE
      WHEN LOWER(channel) IN ('and_eu', 'and_eu_cbt1', 'and_n2_cbt1')
      THEN LOWER(channel)
      ELSE 'unknown'
    END AS channel,
    SUM(CASE WHEN tag = 'create' AND logymd = '2026-05-31' THEN 1 ELSE 0 END) AS register_cnt,
    SUM(CASE WHEN tag = 'create' THEN 1 ELSE 0 END) AS register_cnt_total,
    SUM(CASE WHEN tag = 'login' THEN 1 ELSE 0 END) AS active_cnt,
    SUM(CASE WHEN tag = 'logout' THEN tag_num ELSE 0 END) AS online_dur,
    COUNT(DISTINCT CASE WHEN tag = 'charge' THEN roleid END) AS pay_cnt,
    SUM(CASE WHEN tag = 'charge' THEN tag_num ELSE 0 END) AS pay_amt
  FROM indicator_role
  GROUP BY
    country,
    CASE
      WHEN LOWER(channel) IN ('and_eu', 'and_eu_cbt1', 'and_n2_cbt1')
      THEN LOWER(channel)
      ELSE 'unknown'
    END
) AS t3
  ON t0.country = t3.country;
