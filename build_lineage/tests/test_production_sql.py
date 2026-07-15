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
