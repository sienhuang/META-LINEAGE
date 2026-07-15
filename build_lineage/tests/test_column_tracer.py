from __future__ import annotations

import unittest

from build_lineage.column_tracer import SingleJobColumnTracer
from build_lineage.metadata import MetadataColumn, TableMetadata


SQL = """
WITH date_list AS (
  SELECT p_date, 1 AS diffdays FROM source.calendar
), device AS (
  SELECT IF(SUBSTRING(a.active_info, 1 + d.diffdays, 1) > 0, 1, 0)
           AS is_active,
         d.p_date AS logymd
  FROM adbi.device_behavior a
  LEFT JOIN date_list d ON a.p_date = d.p_date
  WHERE a.app_id = '1001'
)
INSERT OVERWRITE TABLE mt_ads.target PARTITION(logymd, appname)
SELECT COALESCE(SUM(active_cnt), 0) AS active_cnt, logymd, appname
FROM (
  SELECT SUM(is_active) AS active_cnt, logymd, 'game' AS appname
  FROM device GROUP BY logymd
  UNION ALL
  SELECT 0 AS active_cnt, logymd, 'game' AS appname
  FROM mt_ads.retention_a
  UNION ALL
  SELECT 0 AS active_cnt, logymd, 'game' AS appname
  FROM mt_ads.retention_b
) branches
GROUP BY logymd, appname
"""


MULTI_UNION_SQL = """
INSERT OVERWRITE TABLE mt_ads.target_mid
SELECT COALESCE(a.active_cnt_7days, 0) AS active_cnt_7days
FROM dim.country b
CROSS JOIN (
  SELECT 'ios' AS os_name
  UNION ALL SELECT 'android' AS os_name
  UNION ALL SELECT 'unknown' AS os_name
) os_list
LEFT JOIN (
  SELECT COALESCE(SUM(active_cnt_7days), 0) AS active_cnt_7days
  FROM (
    SELECT 0 AS active_cnt_7days FROM dm.registration
    UNION ALL
    SELECT SUM(is_active_7days) AS active_cnt_7days FROM dm.activity
  ) metric_branches
) a ON a.active_cnt_7days >= 0
"""


STAR_PASSTHROUGH_SQL = """
WITH base AS (
  SELECT * FROM dm.accounts
  WHERE logymd = '2026-05-31'
), joined AS (
  SELECT t1.*, t2.online_dur
  FROM base t1
  LEFT JOIN dm.duration t2
    ON t1.accountid = t2.accountid AND t1.zoneid = t2.zoneid
)
INSERT OVERWRITE TABLE mt_ads.star_target
SELECT COUNT(DISTINCT IF(create_date <= '2026-05-31', accountid, NULL))
       AS register_cnt_total
FROM joined
"""


UNALIASED_INSERT_SQL = """
INSERT OVERWRITE TABLE db.target PARTITION(logymd='2026-07-15')
SELECT user_id, SUM(login_cnt)
FROM db.source
GROUP BY user_id
"""


class _MetadataClient:
    def get_table_by_name(self, table_name: str) -> TableMetadata:
        if table_name != "db.target":
            raise AssertionError(table_name)
        return TableMetadata(
            database_name="db",
            table_name="target",
            full_table_name="db.target",
            description=None,
            table_type="external_table",
            columns=(
                MetadataColumn("user_id", "string", 1, None, False, True),
                MetadataColumn("login_cnt", "bigint", 2, None, False, True),
                MetadataColumn("logymd", "string", 1, None, True, True),
            ),
        )


class SingleJobColumnTracerTests(unittest.TestCase):
    def test_traces_value_source_and_constant_union_branches(self) -> None:
        result = SingleJobColumnTracer("hive").trace(SQL, "active_cnt")

        self.assertEqual("mt_ads.target", result.target_table)
        self.assertEqual(
            ["adbi.device_behavior.active_info"],
            [item.ref for item in result.value_sources],
        )
        self.assertEqual(3, len(result.branches))
        self.assertEqual("value", result.branches[0].contribution)
        self.assertEqual("constant_branch", result.branches[1].contribution)
        self.assertEqual("constant_branch", result.branches[2].contribution)
        self.assertEqual(
            ["adbi.device_behavior", "source.calendar"],
            result.branches[0].physical_datasets,
        )
        self.assertEqual(
            ["mt_ads.retention_a"],
            result.branches[1].physical_datasets,
        )
        self.assertTrue(any("LEFT JOIN date_list" in join for join in result.joins))
        output = result.to_dict()
        self.assertNotIn("trace", output)
        self.assertTrue(any(
            "SUBSTRING" in expression
            for expression in output["branches"][0]["value_transformations"]
        ))
        self.assertIn("trace", result.to_dict(include_trace=True))

    def test_rejects_unknown_target_column(self) -> None:
        with self.assertRaisesRegex(ValueError, "is not an INSERT output"):
            SingleJobColumnTracer("hive").trace(SQL, "missing_metric")

    def test_selects_target_union_when_an_unrelated_union_appears_first(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            MULTI_UNION_SQL,
            "active_cnt_7days",
        )

        self.assertEqual(2, len(result.branches))
        self.assertEqual("constant_branch", result.branches[0].contribution)
        self.assertEqual("value", result.branches[1].contribution)
        self.assertEqual(
            ["dm.activity.is_active_7days"],
            [item.ref for item in result.value_sources],
        )
        self.assertEqual([], result.warnings)
        self.assertIn("CROSS JOIN os_list", result.joins)
        self.assertTrue(any(join.startswith("LEFT JOIN a ON") for join in result.joins))

    def test_resolves_value_columns_through_qualified_star(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            STAR_PASSTHROUGH_SQL,
            "register_cnt_total",
        )

        self.assertEqual(
            ["dm.accounts.accountid", "dm.accounts.create_date"],
            [item.ref for item in result.value_sources],
        )

    def test_resolves_unaliased_output_by_target_schema_position(self) -> None:
        result = SingleJobColumnTracer(
            "hive",
            metadata_client=_MetadataClient(),
        ).trace(UNALIASED_INSERT_SQL, "login_cnt")

        self.assertEqual(2, result.target_ordinal)
        self.assertEqual("login_cnt", result.target_field)
        self.assertEqual(
            ["db.source.login_cnt"],
            [item.ref for item in result.value_sources],
        )
        self.assertTrue(any(
            "resolved from target table schema" in warning
            for warning in result.warnings
        ))

    def test_schema_resolution_rejects_output_count_mismatch(self) -> None:
        sql = UNALIASED_INSERT_SQL.replace(
            "SELECT user_id, SUM(login_cnt)",
            "SELECT SUM(login_cnt)",
        ).replace("GROUP BY user_id", "")
        with self.assertRaisesRegex(ValueError, "output count does not match"):
            SingleJobColumnTracer(
                "hive",
                metadata_client=_MetadataClient(),
            ).trace(sql, "login_cnt")


if __name__ == "__main__":
    unittest.main()
