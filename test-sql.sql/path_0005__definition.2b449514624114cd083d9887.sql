-- all-production-sql path_id: 5
-- target_definition_id: definition.2b449514624114cd083d9887
-- jobs: job.100052824_0
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.2b449514624114cd083d9887
-- inlined jobs: job.100052824_0
-- external boundary: w5_ods.create_role.*
-- external boundary: w5_ods.login.*
-- external boundary: w5_ods.logout.*
-- external boundary: w5_ods.charge.*
/* 新增 */
WITH t_create AS (
  SELECT
    roleid AS roleid,
    zoneid AS zoneid,
    TIME AS server_time,
    IF(
      createrole_country IS NULL OR TRIM(createrole_country) IN ('-', ''),
      'unknown',
      LOWER(createrole_country)
    ) AS country,
    CASE
      WHEN LOWER(createrole_channel) = 'and_gb'
      THEN 'and_gb'
      WHEN LOWER(createrole_channel) = 'ios_gb'
      THEN 'ios_gb'
      ELSE 'unknown'
    END AS channel,
    logymd
  FROM w5_ods.create_role
  WHERE
    logymd <= '2026-05-31' AND logymd >= '2026-04-22' AND zoneid > 10000
), t_login /* 活跃 */ AS (
  SELECT
    roleid,
    channel,
    country,
    logymd
  FROM (
    SELECT
      roleid AS roleid,
      'login' AS tag,
      IF(
        createrole_country IS NULL OR TRIM(createrole_country) IN ('-', ''),
        'unknown',
        LOWER(createrole_country)
      ) AS country,
      CASE
        WHEN LOWER(createrole_channel) = 'and_gb'
        THEN 'and_gb'
        WHEN LOWER(createrole_channel) = 'ios_gb'
        THEN 'ios_gb'
        ELSE 'unknown'
      END AS channel,
      ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY TIME) AS rn,
      logymd
    FROM w5_ods.login
    WHERE
      logymd = '2026-05-31' AND logymd >= '2026-04-22' AND zoneid > 10000
  ) AS t
  WHERE
    rn = 1
), t_logout /* 在线时长 */ AS (
  SELECT
    t_login.roleid,
    t_login.channel,
    t_login.country,
    t_logout_agg.tag_num,
    t_login.logymd
  FROM t_login
  INNER JOIN (
    SELECT
      roleid AS roleid,
      SUM(online_time) AS tag_num
    FROM w5_ods.logout
    WHERE
      logymd = '2026-05-31' AND logymd >= '2026-04-22' AND zoneid > 10000
    GROUP BY
      roleid
  ) AS t_logout_agg
    ON t_login.roleid = t_logout_agg.roleid
), t_charge /* 付费 */ AS (
  SELECT
    roleid,
    country,
    channel,
    SUM(money) AS tag_num
  FROM (
    SELECT
      roleid,
      FIRST_VALUE(country) OVER (PARTITION BY roleid ORDER BY server_time ASC) AS country,
      FIRST_VALUE(channel) OVER (PARTITION BY roleid ORDER BY server_time ASC) AS channel,
      money
    FROM (
      SELECT
        roleid,
        IF(
          createrole_country IS NULL OR TRIM(createrole_country) IN ('-', ''),
          'unknown',
          LOWER(createrole_country)
        ) AS country,
        CASE
          WHEN LOWER(createrole_channel) = 'and_gb'
          THEN 'and_gb'
          WHEN LOWER(createrole_channel) = 'ios_gb'
          THEN 'ios_gb'
          ELSE 'unknown'
        END AS channel,
        money,
        TIME AS server_time
      FROM w5_ods.charge
      WHERE
        logymd = '2026-05-31' AND logymd >= '2026-04-22' AND zoneid > 10000
    )
  )
  GROUP BY
    roleid,
    country,
    channel
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
      country,
      logymd,
      0 AS tag_num
    FROM (
      SELECT
        roleid,
        channel,
        country,
        logymd,
        ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY server_time) AS rn
      FROM t_create
    ) AS t
    WHERE
      rn = 1
    UNION ALL
    SELECT
      roleid,
      'login' AS tag,
      channel,
      country,
      logymd,
      0 AS tag_num
    FROM t_login
    UNION ALL
    SELECT
      roleid,
      'logout' AS tag,
      channel,
      country,
      logymd,
      tag_num
    FROM t_logout
    UNION ALL
    SELECT
      roleid,
      'charge' AS tag,
      channel,
      country,
      '2026-05-31' AS logymd,
      tag_num
    FROM t_charge
  ) AS t
), t_dim AS (
  SELECT
    country_code AS country,
    'wefly5' AS appname
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
    AND appname = 'mlbb'
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
    COALESCE(channel, 'unknown') AS channel,
    SUM(CASE WHEN tag = 'create' AND logymd = '2026-05-31' THEN 1 ELSE 0 END) AS register_cnt, /* 新增用户数 */
    SUM(CASE WHEN tag = 'create' THEN 1 ELSE 0 END) AS register_cnt_total, /* 累计注册用户数 */
    SUM(CASE WHEN tag = 'login' THEN 1 ELSE 0 END) AS active_cnt, /* DAU */
    SUM(CASE WHEN tag = 'logout' THEN tag_num ELSE 0 END) AS online_dur, /* 在线时长 */
    COUNT(DISTINCT CASE WHEN tag = 'charge' THEN roleid END) AS pay_cnt, /* 付费用户数 */
    SUM(CASE WHEN tag = 'charge' THEN tag_num ELSE 0 END) AS pay_amt /* 付费金额 */
  FROM indicator_role
  GROUP BY
    COALESCE(country, 'unknown'),
    COALESCE(channel, 'unknown')
) AS t3
  ON t0.country = t3.country;
