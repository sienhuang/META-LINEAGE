from __future__ import annotations

import tempfile
import unittest
from pathlib import Path

import sqlglot

from build_lineage.column_tracer import SingleJobColumnTracer
from build_lineage.production_sql import (
    ProductionSqlGenerator,
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


if __name__ == "__main__":
    unittest.main()
