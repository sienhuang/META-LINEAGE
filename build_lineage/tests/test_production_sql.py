from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import sqlglot

from build_lineage.column_tracer import SingleJobColumnTracer
from build_lineage.production_sql import (
    ProductionSqlGenerator,
    _prune_query,
    _validate_scope_contracts,
    write_production_sql,
)
from build_lineage.metadata import MetadataColumn, TableMetadata
from build_lineage.tests.test_column_tracer import (
    SQL,
    STAR_PASSTHROUGH_SQL,
    UNALIASED_INSERT_SQL,
    _MetadataClient,
)


STATIC_PARTITION_SQL = """
INSERT OVERWRITE TABLE mt_ads.target
PARTITION(logymd='2026-05-31', appname='game')
SELECT COALESCE(a.metric, 0) AS metric
FROM (
  SELECT COALESCE(SUM(metric), 0) AS metric, logymd
  FROM (
    SELECT 0 AS metric, '2026-05-31' AS logymd FROM dm.zero_rows
    UNION ALL
    SELECT SUM(value) AS metric, '2026-05-31' AS logymd FROM dm.source_values
  ) branches
  GROUP BY logymd
) a
"""


STATIC_PARTITION_UNION_SQL = """
INSERT OVERWRITE TABLE mt_ads.union_target
PARTITION(logymd='2026-05-31')
SELECT SUM(value) AS metric FROM dm.source_a
UNION ALL
SELECT SUM(value) AS metric FROM dm.source_b
"""


PARENTHESIZED_STATIC_PARTITION_SQL = """
WITH source AS (
  SELECT value FROM dm.source_values
)
INSERT OVERWRITE TABLE mt_ads.target
PARTITION(logymd='2026-05-31')
(SELECT SUM(value) AS metric FROM source)
"""


RESERVED_STAR_COLUMN_SQL = """
INSERT OVERWRITE TABLE db.target PARTITION(logymd='2026-07-15')
SELECT `from`
FROM (SELECT * FROM db.source) source
"""


DISTRIBUTE_BY_SQL = """
INSERT OVERWRITE TABLE mt_ads.distributed_target
PARTITION(logymd='2026-07-15', appid)
SELECT area_id, appid
FROM (
  SELECT roleid, zoneid, os, device, ip_country, area_id, appid
  FROM dm.role_behavior
) a
DISTRIBUTE BY ABS(HASH(roleid, zoneid, os, device, ip_country)) % 20
"""


SORT_BY_SQL = """
INSERT OVERWRITE TABLE mt_ads.sorted_target
SELECT accountid
FROM (
  SELECT accountid, event_time
  FROM dm.account_events
) events
DISTRIBUTE BY accountid
SORT BY event_time DESC
"""


UNQUALIFIED_STAR_SOURCE_SQL = """
INSERT OVERWRITE TABLE mt_ads.star_join_target
SELECT COALESCE(last_network_name, 'unknown') AS last_network_name
FROM (
  SELECT roleid FROM dm.activity
) activity
LEFT JOIN (
  SELECT * FROM dim.roles
) role_dim ON activity.roleid = role_dim.roleid
"""


CORRELATED_FILTER_SQL = """
WITH current_rows AS (
  SELECT event_time, adjust_id, appid
  FROM db.events
), history AS (
  SELECT adjust_id, appid
  FROM db.history
)
INSERT OVERWRITE TABLE db.target
SELECT t1.event_time AS event_time
FROM (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY appid, adjust_id ORDER BY event_time
  ) AS rn
  FROM current_rows
) t1
WHERE rn = 1
  AND NOT EXISTS (
    SELECT 1 FROM history t2
    WHERE t1.appid = t2.appid AND t1.adjust_id = t2.adjust_id
  )
"""


UNION_DUPLICATE_LATER_BRANCH_NAME_SQL = """
WITH combined AS (
  SELECT id, table_name, user_name, tool_source, task_type, task_id
  FROM db.first_source
  UNION ALL
  SELECT task_id, table_name, owner_email AS user_name,
         tool_source, task_type, task_id
  FROM db.second_source
), projected AS (
  SELECT task_id, id AS query_id
  FROM combined
)
INSERT OVERWRITE TABLE db.target
SELECT task_id FROM projected
"""


CASE_INSENSITIVE_DERIVED_ALIAS_SQL = """
WITH metrics AS (
  SELECT id, value AS metric FROM db.source
)
INSERT OVERWRITE TABLE db.target
SELECT M.METRIC AS metric
FROM metrics m
"""


WINDOW_OUTPUT_FILTER_SQL = """
WITH ranked AS (
  SELECT accountid,
         RANK() OVER (PARTITION BY deviceid ORDER BY active_days DESC) AS ranknum
  FROM db.accounts
), flagged AS (
  SELECT accountid, 1 AS small_account_flag
  FROM ranked
  WHERE ranknum > 1
)
INSERT OVERWRITE TABLE db.target
SELECT small_account_flag FROM flagged
"""


WINDOW_OUTPUT_FILTER_UNION_SQL = """
WITH login AS (
  SELECT deviceid, roleid AS accountid, MAX(activedays) AS activedays,
         MAX(level) AS level, MIN(usercreatetime) AS usercreatetime
  FROM db.login GROUP BY roleid, deviceid
), battle AS (
  SELECT accountid, COUNT(*) AS battle_count FROM db.battle GROUP BY accountid
), adv AS (SELECT accountid, first_mt_country FROM db.adv),
login_battle AS (
  SELECT deviceid, login.accountid, activedays, level, usercreatetime,
         COALESCE(battle_count, 0) AS battle_count
  FROM login LEFT JOIN battle ON login.accountid = battle.accountid
), base_data AS (
  SELECT deviceid, login_battle.accountid, activedays, level, usercreatetime,
         battle_count, first_mt_country
  FROM adv RIGHT JOIN login_battle ON adv.accountid = login_battle.accountid
), ranknum_data AS (
  SELECT accountid, first_mt_country,
         RANK() OVER (PARTITION BY deviceid ORDER BY activedays DESC, level DESC,
                      battle_count DESC, usercreatetime ASC) AS ranknum
  FROM base_data
), small_account AS (
  SELECT accountid, first_mt_country, 1 AS small_account_flag
  FROM ranknum_data WHERE ranknum > 1 GROUP BY accountid, first_mt_country
), flag_account AS (
  SELECT accountid, first_mt_country, 0 AS small_account_flag
  FROM ranknum_data AS a
  WHERE NOT EXISTS (SELECT accountid FROM small_account AS b
                    WHERE a.accountid = b.accountid)
  GROUP BY accountid, first_mt_country
  UNION
  SELECT accountid, first_mt_country, 1 AS small_account_flag FROM small_account
)
INSERT OVERWRITE TABLE db.target
SELECT accountid, COALESCE(first_mt_country, 'unknown') AS first_mt_country,
       small_account_flag FROM flag_account
"""


class _StarMetadataClient:
    def get_table(self, database_name: str, table_name: str) -> TableMetadata:
        names = {
            "left_source": ("id", "metric"),
            "right_source": ("id", "description"),
        }[table_name]
        return TableMetadata(
            database_name=database_name,
            table_name=table_name,
            full_table_name=f"{database_name}.{table_name}",
            description=None,
            table_type="external_table",
            columns=tuple(
                MetadataColumn(name, "string", index, None, False, True)
                for index, name in enumerate(names, start=1)
            ),
        )


class ProductionSqlGeneratorTests(unittest.TestCase):
    def test_generates_validated_minimal_query(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(SQL, "active_cnt")

        result = ProductionSqlGenerator("hive").generate(
            SQL,
            "active_cnt",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(
            "ast_scope_and_column_lineage",
            result.summary()["validation_level"],
        )
        self.assertEqual(3, result.union_branch_count)
        self.assertEqual(
            ("adbi.device_behavior.active_info",),
            result.value_sources,
        )
        self.assertNotIn("INSERT", result.sql.upper())
        self.assertIn("0 AS active_cnt", result.sql)
        self.assertIn("LEFT JOIN date_list AS d", result.sql)
        self.assertIn("logymd", result.sql)
        self.assertNotIn("active_cnt_30days", result.sql)
        parsed = sqlglot.parse_one(result.sql, read="hive")
        self.assertEqual(
            ["active_cnt", "logymd", "appname"],
            [item.alias_or_name for item in parsed.selects],
        )

    def test_writes_sql_atomically(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "nested" / "production.sql"

            written = write_production_sql("SELECT 1;\n", output)

            self.assertEqual(output.resolve(), written)
            self.assertEqual("SELECT 1;\n", output.read_text(encoding="utf-8"))
            self.assertFalse(output.with_suffix(".sql.tmp").exists())

    def test_group_by_may_reference_a_computed_output_alias(self) -> None:
        query = sqlglot.parse_one("""
            SELECT SUM(value) AS metric, '2026-05-31' AS logymd
            FROM (SELECT value FROM db.source) source
            GROUP BY logymd
        """, read="hive")

        _validate_scope_contracts(query)

    def test_validates_scalar_subquery_columns_in_their_own_scope(self) -> None:
        query = sqlglot.parse_one("""
            WITH version_counts AS (
              SELECT COUNT(*) AS version_count
              FROM db.valid_versions
            )
            SELECT official_version, rn
            FROM (
              SELECT official_version, ROW_NUMBER() OVER () AS rn
              FROM db.valid_versions
            ) ranked_versions
            WHERE rn <= (
              SELECT CASE WHEN version_count > 1 THEN 2 ELSE 1 END
              FROM version_counts
            )
        """, read="hive")

        _validate_scope_contracts(query)

    def test_preserves_outer_columns_used_by_correlated_subquery(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            CORRELATED_FILTER_SQL,
            "event_time",
        )

        result = ProductionSqlGenerator("hive").generate(
            CORRELATED_FILTER_SQL,
            "event_time",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(("db.events.event_time",), result.value_sources)
        self.assertIn("adjust_id", result.sql)
        self.assertIn("appid", result.sql)

    def test_union_pruning_uses_ordinal_not_duplicate_later_branch_name(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            UNION_DUPLICATE_LATER_BRANCH_NAME_SQL,
            "task_id",
        )

        result = ProductionSqlGenerator("hive").generate(
            UNION_DUPLICATE_LATER_BRANCH_NAME_SQL,
            "task_id",
            trace,
        )

        query = sqlglot.parse_one(result.sql, read="hive")
        union = next(query.find_all(sqlglot.exp.Union))
        branches = [union.this, union.expression]
        self.assertEqual([1, 1], [len(branch.selects) for branch in branches])
        self.assertEqual(
            ("db.first_source.task_id", "db.second_source.task_id"),
            result.value_sources,
        )

    def test_derived_alias_lookup_is_case_insensitive_for_hive(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            CASE_INSENSITIVE_DERIVED_ALIAS_SQL,
            "metric",
        )

        result = ProductionSqlGenerator("hive").generate(
            CASE_INSENSITIVE_DERIVED_ALIAS_SQL,
            "metric",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(("db.source.value",), result.value_sources)
        self.assertIn("value AS metric", result.sql)

    def test_preserves_window_output_used_by_downstream_filter(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            WINDOW_OUTPUT_FILTER_SQL,
            "small_account_flag",
        )

        result = ProductionSqlGenerator("hive").generate(
            WINDOW_OUTPUT_FILTER_SQL,
            "small_account_flag",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertIn("RANK() OVER", result.sql)
        self.assertIn("ranknum > 1", result.sql)

    def test_preserves_window_output_used_by_union_branch_filter(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            WINDOW_OUTPUT_FILTER_UNION_SQL,
            "small_account_flag",
        )

        result = ProductionSqlGenerator("hive").generate(
            WINDOW_OUTPUT_FILTER_UNION_SQL,
            "small_account_flag",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertIn("RANK() OVER", result.sql)
        self.assertIn("ranknum > 1", result.sql)

    def test_rejects_a_genuinely_missing_derived_output(self) -> None:
        query = sqlglot.parse_one("""
            SELECT missing_metric
            FROM (SELECT present_metric FROM db.source) derived
        """, read="hive")

        with self.assertRaisesRegex(
            ValueError,
            "derived query does not output column 'missing_metric'",
        ):
            _validate_scope_contracts(query)

    def test_preserves_group_grain_and_appends_static_partitions(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            STATIC_PARTITION_SQL,
            "metric",
        )

        result = ProductionSqlGenerator("hive").generate(
            STATIC_PARTITION_SQL,
            "metric",
            trace,
        )

        self.assertEqual(
            ("metric", "logymd", "appname"),
            result.output_columns,
        )
        self.assertIn("'2026-05-31' AS logymd", result.sql)
        self.assertIn("'game' AS appname", result.sql)
        self.assertIn(
            "COALESCE(SUM(metric), 0) AS metric,\n    logymd",
            result.sql,
        )

    def test_appends_static_partitions_to_every_union_branch(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            STATIC_PARTITION_UNION_SQL,
            "metric",
        )

        result = ProductionSqlGenerator("hive").generate(
            STATIC_PARTITION_UNION_SQL,
            "metric",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(("metric", "logymd"), result.output_columns)
        self.assertEqual(2, result.union_branch_count)
        parsed = sqlglot.parse_one(result.sql, read="hive")
        self.assertIsInstance(parsed, sqlglot.exp.Union)
        branches = [parsed.this, parsed.expression]
        self.assertTrue(all(
            [item.alias_or_name for item in branch.selects]
            == ["metric", "logymd"]
            for branch in branches
        ))

    def test_unwraps_parenthesized_static_partition_query(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            PARENTHESIZED_STATIC_PARTITION_SQL,
            "metric",
        )

        result = ProductionSqlGenerator("hive").generate(
            PARENTHESIZED_STATIC_PARTITION_SQL,
            "metric",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(("metric", "logymd"), result.output_columns)
        parsed = sqlglot.parse_one(result.sql, read="hive")
        self.assertIsInstance(parsed, sqlglot.exp.Select)
        self.assertIn("'2026-05-31' AS logymd", result.sql)

    def test_quotes_reserved_column_expanded_from_star(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            RESERVED_STAR_COLUMN_SQL,
            "from",
        )

        result = ProductionSqlGenerator("hive").generate(
            RESERVED_STAR_COLUMN_SQL,
            "from",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(("from", "logymd"), result.output_columns)
        self.assertIn("`from`", result.sql)

    def test_prunes_query_with_qualified_star_passthrough(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            STAR_PASSTHROUGH_SQL,
            "register_cnt_total",
        )

        result = ProductionSqlGenerator("hive").generate(
            STAR_PASSTHROUGH_SQL,
            "register_cnt_total",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(
            ("dm.accounts.accountid", "dm.accounts.create_date"),
            result.value_sources,
        )
        self.assertNotIn("t1.*", result.sql)
        self.assertIn("t1.accountid", result.sql)
        self.assertIn("t1.create_date", result.sql)
        self.assertNotIn("t2.online_dur", result.sql)

    def test_generates_from_schema_resolved_unaliased_output(self) -> None:
        trace = SingleJobColumnTracer(
            "hive",
            metadata_client=_MetadataClient(),
        ).trace(UNALIASED_INSERT_SQL, "login_cnt")

        result = ProductionSqlGenerator("hive").generate(
            UNALIASED_INSERT_SQL,
            "login_cnt",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(("user_id", "login_cnt", "logymd"), result.output_columns)
        self.assertIn("SUM(login_cnt) AS login_cnt", result.sql)

    def test_preserves_derived_outputs_used_by_distribute_by(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            DISTRIBUTE_BY_SQL,
            "area_id",
        )

        result = ProductionSqlGenerator("hive").generate(
            DISTRIBUTE_BY_SQL,
            "area_id",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertIn("DISTRIBUTE BY", result.sql)
        parsed = sqlglot.parse_one(result.sql, read="hive")
        derived = next(parsed.find_all(sqlglot.exp.Subquery))
        self.assertEqual(
            ["roleid", "zoneid", "os", "device", "ip_country", "area_id", "appid"],
            [item.alias_or_name for item in derived.this.selects],
        )

    def test_preserves_derived_outputs_used_only_by_sort_by(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            SORT_BY_SQL,
            "accountid",
        )

        result = ProductionSqlGenerator("hive").generate(
            SORT_BY_SQL,
            "accountid",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertIn("SORT BY", result.sql)
        parsed = sqlglot.parse_one(result.sql, read="hive")
        derived = next(parsed.find_all(sqlglot.exp.Subquery))
        self.assertEqual(
            ["accountid", "event_time"],
            [item.alias_or_name for item in derived.this.selects],
        )

    def test_resolves_unqualified_column_to_unique_star_source(self) -> None:
        trace = SingleJobColumnTracer("hive").trace(
            UNQUALIFIED_STAR_SOURCE_SQL,
            "last_network_name",
        )

        result = ProductionSqlGenerator("hive").generate(
            UNQUALIFIED_STAR_SOURCE_SQL,
            "last_network_name",
            trace,
        )

        self.assertTrue(result.validated)
        self.assertEqual(
            ("dim.roles.last_network_name",),
            result.value_sources,
        )
        parsed = sqlglot.parse_one(result.sql, read="hive")
        role_dim = next(
            item for item in parsed.find_all(sqlglot.exp.Subquery)
            if item.alias_or_name == "role_dim"
        )
        self.assertEqual(
            ["last_network_name", "roleid"],
            [item.alias_or_name for item in role_dim.this.selects],
        )

    def test_schema_rules_out_physical_star_that_lacks_unqualified_column(self) -> None:
        query = sqlglot.parse_one("""
            SELECT metric
            FROM (SELECT * FROM db.left_source) a
            LEFT JOIN (SELECT * FROM db.right_source) c ON a.id = c.id
        """, read="hive")

        _prune_query(query, {"metric"}, _StarMetadataClient())

        sources = {
            subquery.alias_or_name: [
                item.alias_or_name for item in subquery.this.selects
            ]
            for subquery in query.find_all(sqlglot.exp.Subquery)
        }
        self.assertEqual(["id", "metric"], sources["a"])
        self.assertEqual(["id"], sources["c"])

    def test_ignores_nested_stars_that_cannot_output_unqualified_column(self) -> None:
        query = sqlglot.parse_one("""
            SELECT event_channel
            FROM dm.events kk
            LEFT JOIN (
              SELECT * FROM (
                SELECT resource_id FROM dim.prep_resources
              ) nested
            ) prep ON kk.resource_id = prep.resource_id
            LEFT JOIN (
              SELECT * FROM (
                SELECT resource_id FROM dim.dataset_resources
              ) nested
            ) dataset ON kk.resource_id = dataset.resource_id
            LEFT JOIN (
              SELECT * FROM (
                SELECT resource_id FROM dim.report_resources
              ) nested
            ) report ON kk.resource_id = report.resource_id
            LEFT JOIN (
              SELECT * FROM (
                SELECT resource_id FROM dim.dashboard_resources
              ) nested
            ) dashboard ON kk.resource_id = dashboard.resource_id
        """, read="hive")

        _prune_query(query, {"event_channel"})

        self.assertEqual(
            ["event_channel"],
            [item.alias_or_name for item in query.selects],
        )

    def test_rejects_ambiguous_unqualified_column_from_multiple_stars(self) -> None:
        query = sqlglot.parse_one("""
            SELECT COALESCE(metric, 0) AS metric
            FROM (SELECT * FROM dm.source_a) a
            JOIN (SELECT * FROM dm.source_b) b ON a.id = b.id
        """, read="hive")

        with self.assertRaisesRegex(
            ValueError,
            "ambiguous unqualified column 'metric'",
        ):
            _prune_query(query, {"metric"})


if __name__ == "__main__":
    unittest.main()
