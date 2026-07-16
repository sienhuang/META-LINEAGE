from __future__ import annotations

import unittest

from build_lineage.builder import SingleJobProductionBuilder
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


DUPLICATE_ALIAS_INSERT_SQL = """
INSERT OVERWRITE TABLE db.target PARTITION(logymd='2026-07-15')
SELECT source.user_id AS user_id, source.login_cnt AS user_id
FROM db.source
"""


PARENTHESIZED_INSERT_SQL = """
WITH source AS (
  SELECT * FROM db.source
)
INSERT OVERWRITE TABLE db.target PARTITION(logymd='2026-07-15')
(SELECT user_id FROM source)
"""


PARENTHESIZED_UNQUALIFIED_STAR_JOIN_SQL = """
WITH source AS (
  SELECT * FROM db.source
), counts AS (
  SELECT user_id, COUNT(*) AS event_cnt
  FROM source
  GROUP BY user_id
)
INSERT OVERWRITE TABLE db.target PARTITION(logymd='2026-07-15')
(SELECT user_id
 FROM (SELECT source.*, counts.event_cnt
       FROM source LEFT JOIN counts
         ON source.user_id = counts.user_id) joined)
"""


REUSED_ALIAS_STAR_SQL = """
INSERT OVERWRITE TABLE mt_ads.alias_target
SELECT nested.metric AS metric
FROM (
  SELECT a.metric AS metric, a.id AS id
  FROM (SELECT * FROM dm.correct_source) a
) nested
LEFT JOIN (SELECT * FROM dm.wrong_source) a ON nested.id = a.id
"""


CTE_REUSED_ALIAS_STAR_SQL = """
WITH correct_rows AS (
  SELECT * FROM dm.correct_source
), wrong_rows AS (
  SELECT * FROM dm.wrong_source
), nested AS (
  SELECT t.metric AS metric, t.id AS id
  FROM correct_rows t
), unrelated AS (
  SELECT t.metric AS metric, t.id AS id
  FROM wrong_rows t
)
INSERT OVERWRITE TABLE mt_ads.alias_target
SELECT t.metric AS metric
FROM nested t
LEFT JOIN unrelated u ON t.id = u.id
"""


CTE_JOIN_CONTEXT_STAR_SQL = """
WITH newbies AS (
  SELECT roleid FROM dm.newbies
), battles AS (
  SELECT a.roleid, a.battle_time
  FROM dm.correct_source a
  JOIN newbies b ON a.roleid = b.roleid
), unrelated AS (
  SELECT t.rank_metric, t.roleid FROM dm.wrong_source t
)
INSERT OVERWRITE TABLE mt_ads.alias_target
SELECT t.battle_time AS battle_time
FROM (SELECT * FROM battles) t
LEFT JOIN unrelated u ON t.roleid = u.roleid
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

    def test_traces_parenthesized_insert_query(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            PARENTHESIZED_INSERT_SQL,
            "user_id",
        )

        self.assertEqual(
            ["db.source.user_id"],
            [item.ref for item in result.value_sources],
        )

    def test_resolves_unqualified_star_from_only_viable_join_source(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            PARENTHESIZED_UNQUALIFIED_STAR_JOIN_SQL,
            "user_id",
        )

        self.assertEqual(
            ["db.source.user_id"],
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

    def test_resolves_duplicate_aliases_by_target_schema_position(self) -> None:
        tracer = SingleJobColumnTracer(
            "hive",
            metadata_client=_MetadataClient(),
        )

        user_id = tracer.trace(DUPLICATE_ALIAS_INSERT_SQL, "user_id")
        login_cnt = tracer.trace(DUPLICATE_ALIAS_INSERT_SQL, "login_cnt")

        self.assertEqual(1, user_id.target_ordinal)
        self.assertEqual(["db.source.user_id"], [x.ref for x in user_id.value_sources])
        self.assertEqual(2, login_cnt.target_ordinal)
        self.assertEqual(
            ["db.source.login_cnt"],
            [x.ref for x in login_cnt.value_sources],
        )

        production = SingleJobProductionBuilder(
            "hive",
            metadata_client=_MetadataClient(),
        ).build(DUPLICATE_ALIAS_INSERT_SQL, "user_id").production
        self.assertEqual(("user_id", "logymd"), production.output_columns)

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

    def test_star_resolution_uses_node_local_scope_when_aliases_repeat(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            REUSED_ALIAS_STAR_SQL,
            "metric",
        )

        self.assertEqual(
            ["dm.correct_source.metric"],
            [item.ref for item in result.value_sources],
        )

    def test_star_resolution_matches_full_scope_before_global_alias_fallback(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            CTE_REUSED_ALIAS_STAR_SQL,
            "metric",
        )

        self.assertEqual(
            ["dm.correct_source.metric"],
            [item.ref for item in result.value_sources],
        )

    def test_star_resolution_matches_trimmed_join_context_with_cte(self) -> None:
        result = SingleJobColumnTracer("hive").trace(
            CTE_JOIN_CONTEXT_STAR_SQL,
            "battle_time",
        )

        self.assertEqual(
            ["dm.correct_source.battle_time"],
            [item.ref for item in result.value_sources],
        )


if __name__ == "__main__":
    unittest.main()
