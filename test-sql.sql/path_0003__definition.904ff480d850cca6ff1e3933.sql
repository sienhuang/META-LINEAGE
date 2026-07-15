-- all-production-sql path_id: 3
-- target_definition_id: definition.904ff480d850cca6ff1e3933
-- jobs: job.100050909_0
-- MetaWIKI · reconstructed column production SQL
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- target_definition_id: definition.904ff480d850cca6ff1e3933
-- inlined jobs: job.100050909_0
WITH t_create /* AND     zoneid BETWEEN 0 AND 999999  -- 默认不筛选区服，需要筛选时修改此行（如：1000 AND 9999） */ AS (
  SELECT
    roleid AS roleid,
    time AS server_time,
    zoneid AS zoneid,
    logymd AS logymd,
    client_ip AS client_ip,
    CASE WHEN LOWER(channel) IN ('and_ztd') THEN LOWER(channel) ELSE 'unknown' END AS channel,
    LOWER(COALESCE(CAST(createrole_country AS STRING), 'unknown')) AS country
  FROM tgame_ods.gameserver_create_role
  WHERE
    logymd <= '2026-05-31' AND logymd >= '2026-04-10'
), t_login AS (
  SELECT
    roleid,
    tag,
    client_ip,
    channel,
    logymd,
    country,
    targe_num,
    rn
  FROM (
    SELECT
      roleid,
      'login' AS tag,
      client_ip AS client_ip,
      CASE WHEN LOWER(channel) IN ('and_ztd') THEN LOWER(channel) ELSE 'unknown' END AS channel,
      logymd,
      country,
      0 AS targe_num,
      ROW_NUMBER() OVER (PARTITION BY roleid ORDER BY m__server_time) AS rn
    FROM (
      SELECT
        client_ip AS client_ip,
        roleid AS roleid,
        time AS m__server_time,
        logymd AS logymd,
        LOWER(createrole_channel) AS channel,
        LOWER(COALESCE(CAST(createrole_country AS STRING), 'unknown')) AS country
      FROM tgame_ods.gameserver_login
      WHERE
        logymd = '2026-05-31' AND logymd >= '2026-04-10'
    ) AS t1
  ) AS t2
  WHERE
    rn = 1 AND logymd = '2026-05-31'
), t_logout_agg /* 【关键修改】将 logout 的 JOIN 提取为独立 CTE，避免在 UNION ALL 内部嵌套 JOIN */ AS (
  SELECT
    roleid,
    logymd,
    SUM(online_time) AS tag_num
  FROM (
    SELECT
      roleid AS roleid,
      online_time AS online_time,
      logymd AS logymd
    FROM tgame_ods.gameserver_logout
    WHERE
      logymd = '2026-05-31' AND logymd >= '2026-04-10'
  ) AS t
  GROUP BY
    roleid,
    logymd
), t_logout AS (
  SELECT
    t_logout_agg.roleid,
    'logout' AS tag,
    CASE WHEN t_login.channel IN ('and_ztd') THEN t_login.channel ELSE 'unknown' END AS channel,
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
      usercreateymd AS logymd,
      country,
      0 AS tag_num
    FROM (
      SELECT
        roleid,
        CASE WHEN channel IN ('and_ztd') THEN channel ELSE 'unknown' END AS channel,
        logymd AS usercreateymd,
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
    /* 新增 */
    UNION ALL
    SELECT
      roleid,
      tag,
      channel,
      logymd,
      country,
      tag_num
    FROM t_logout
  ) AS t
), t_dim /* 维度表：从 dim_gamebi_country 读取国家维度 */ AS (
  SELECT
    country_code AS country,
    'wefly' AS appname
  FROM mt_dim.dim_gamebi_country
  WHERE
    logymd = (
      SELECT
        MAX(logymd)
      FROM mt_dim.dim_gamebi_country
    ) /* 取最新分区 */
    AND startdate <= '2026-05-31'
    AND appname = 'nova'
    AND is_online = 1
    AND definition_type = 0
  GROUP BY
    country_code,
    appname
)
SELECT
  COALESCE(active_cnt, 0) AS active_cnt
FROM t_dim AS t0
LEFT JOIN (
  SELECT
    COALESCE(t1.country, 'unknown') AS country,
    COALESCE(t1.channel, 'unknown') AS channel,
    t1.register_cnt,
    t1.active_cnt,
    t1.pay_cnt,
    t1.pay_amt,
    t1.register_cnt_total,
    t1.online_dur
  FROM (
    SELECT
      country,
      channel,
      SUM(CASE WHEN tag = 'create' THEN 1 ELSE 0 END) AS register_cnt_total,
      SUM(CASE WHEN tag = 'login' THEN 1 ELSE 0 END) AS active_cnt,
      SUM(CASE WHEN tag = 'charge' THEN tag_num ELSE 0 END) AS pay_amt,
      SUM(CASE WHEN tag = 'create' AND logymd = '2026-05-31' THEN 1 ELSE 0 END) AS register_cnt,
      SUM(CASE WHEN tag = 'logout' THEN tag_num ELSE 0 END) AS online_dur,
      COUNT(DISTINCT CASE WHEN tag = 'charge' THEN roleid ELSE NULL END) AS pay_cnt
    FROM indicator_role
    GROUP BY
      country,
      channel
  ) AS t1
) AS t3
  ON t0.country = t3.country;
