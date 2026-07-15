-- MetaWIKI · single-job column production SQL
-- job_id: job.100021029_0
-- target: mt_ads.ads_gamebi_roger_primary_di.active_cnt
-- scope: current job only; physical tables are boundaries
WITH date_list AS (
  SELECT
    p_date,
    DATE_ADD(p_date, (
      ROW_NUMBER() OVER (PARTITION BY p_date ORDER BY p_date) - 1
    ) * -1) AS logymd
  FROM (
    SELECT
      p_date
    FROM (
      SELECT
        REPEAT(CONCAT('2026-05-31', ','), 30) AS rep_date
    )
    LATERAL VIEW
    EXPLODE(SPLIT(rep_date, ',')) tbl AS p_date
  )
  WHERE
    p_date <> ''
), dm_sdk_device_df AS (
  SELECT
    LOWER(IF(TRIM(country) IN ('-', ''), 'unknown', TRIM(country))) AS country, /* 首次创号国 */
    LOWER(TRIM(os)) AS os,
    LOWER(TRIM(network_name)) AS network,
    IF(SUBSTRING(active_info, 1 + diffdays, 1) > 0, 1, 0) AS is_active,
    logymd
  FROM (
    SELECT
      a.country,
      a.os,
      a.network_name,
      SUBSTRING(a.active_info, 1, 60) AS active_info, /* 截取59位 */
      c.logymd,
      DATEDIFF('2026-05-31', c.logymd) AS diffdays /* 数据日期与业务日期相差天数 */
    FROM adbi.dm_sdk_device_multi_behavior_ug_df AS a
    LEFT JOIN date_list AS c
      ON a.p_date = c.p_date
    WHERE
      a.p_date = '2026-05-31' AND a.app_id = '1001' AND a.create_date <= c.logymd
  ) AS t1
)
SELECT
  active_cnt /*	活跃玩家数 */
FROM (
  SELECT
    COALESCE(SUM(active_cnt), 0) AS active_cnt
  FROM (
    SELECT
      logymd AS date_range,
      country,
      os,
      network,
      SUM(is_active) AS active_cnt,
      logymd
    FROM dm_sdk_device_df
    GROUP BY
      country,
      os,
      network,
      logymd
    UNION ALL
    SELECT
      register_date AS date_range,
      country,
      os,
      network,
      0 AS active_cnt,
      register_date AS logymd
    FROM mt_ads.ads_gamebi_create_reten_ltv_df
    WHERE
      logymd = '2026-05-31'
      AND register_date BETWEEN '2026-05-02' AND '2026-05-31'
      AND granularity_type = 'device'
    UNION ALL
    SELECT
      logymd AS date_range,
      country,
      os,
      network,
      0 AS active_cnt,
      logymd
    FROM mt_ads.ads_gamebi_active_reten_di
    WHERE
      logymd BETWEEN '2026-05-02' AND '2026-05-31' AND granularity_type = 'device'
  )
  GROUP BY
    date_range,
    COALESCE(country, 'unknown'),
    COALESCE(os, 'unknown'),
    COALESCE(network, 'unknown'),
    logymd
);
