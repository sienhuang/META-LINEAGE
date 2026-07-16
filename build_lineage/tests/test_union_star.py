from __future__ import annotations

import unittest

import sqlglot
from sqlglot import exp

from build_lineage.builder import SingleJobProductionBuilder
from build_lineage.metadata import MetadataColumn, TableMetadata
from build_lineage.sql_parser import SqlStructureError
from build_lineage.union_star import (
    expand_derived_union_stars,
    expand_simple_union_stars,
)


UNION_STAR_INSERT_SQL = """
INSERT OVERWRITE TABLE db.target PARTITION(logymd, app_id)
SELECT id, metric, '2026-07-15' AS logymd, app_id
FROM db.current_rows
UNION ALL
SELECT *
FROM db.previous_rows
WHERE logymd = '2026-07-14'
"""


DERIVED_UNION_STAR_INSERT_SQL = """
WITH first_rows AS (
  SELECT act_table_name, query_id FROM db.impala_queries
), second_rows AS (
  SELECT act_table_name, tqs_id FROM db.leap_queries
)
INSERT OVERWRITE TABLE db.target
SELECT query_id
FROM (
  SELECT * FROM first_rows
  UNION ALL
  SELECT * FROM second_rows
) combined
"""


DERIVED_CTE_PHYSICAL_STAR_INSERT_SQL = """
WITH previous AS (
  SELECT * FROM db.previous_rows
)
INSERT OVERWRITE TABLE db.target
SELECT id, metric, logymd, app_id FROM db.current_rows
UNION ALL
SELECT * FROM previous
"""


class _MetadataClient:
    def get_table(self, database_name: str, table_name: str) -> TableMetadata:
        if (database_name, table_name) != ("db", "previous_rows"):
            raise AssertionError((database_name, table_name))
        return TableMetadata(
            database_name="db",
            table_name="previous_rows",
            full_table_name="db.previous_rows",
            description=None,
            table_type="external_table",
            columns=(
                MetadataColumn("id", "string", 1, None, False, True),
                MetadataColumn("metric", "bigint", 2, None, False, True),
                MetadataColumn("logymd", "string", 1, None, True, True),
                MetadataColumn("app_id", "string", 2, None, True, True),
            ),
        )

    def get_table_by_name(self, table_name: str) -> TableMetadata:
        raise AssertionError(f"unexpected target schema lookup: {table_name}")


class UnionStarExpansionTests(unittest.TestCase):
    def test_expands_nonfirst_simple_star_in_physical_schema_order(self) -> None:
        query = sqlglot.parse_one(
            "SELECT id, metric, logymd, app_id FROM db.current_rows "
            "UNION ALL SELECT * FROM db.previous_rows",
            read="hive",
        )

        expand_simple_union_stars(query, _MetadataClient())

        branches = _flatten_union(query)
        self.assertEqual(
            ["id", "metric", "logymd", "app_id"],
            [item.alias_or_name for item in branches[1].expressions],
        )

    def test_rejects_metadata_count_mismatch(self) -> None:
        query = sqlglot.parse_one(
            "SELECT id, metric, logymd FROM db.current_rows "
            "UNION ALL SELECT * FROM db.previous_rows",
            read="hive",
        )

        with self.assertRaisesRegex(
            SqlStructureError,
            "metadata has 4 columns.*explicit UNION branch has 3",
        ):
            expand_simple_union_stars(query, _MetadataClient())

    def test_leaves_non_union_star_unchanged(self) -> None:
        query = sqlglot.parse_one(
            "SELECT * FROM db.previous_rows",
            read="hive",
        )

        expand_simple_union_stars(query, _MetadataClient())

        self.assertIsInstance(query.expressions[0], exp.Star)

    def test_leaves_complex_union_star_unchanged(self) -> None:
        query = sqlglot.parse_one(
            "SELECT id, metric, logymd, app_id FROM db.current_rows "
            "UNION ALL SELECT p.* FROM db.previous_rows p "
            "JOIN db.extra e ON p.id = e.id",
            read="hive",
        )

        expand_simple_union_stars(query, _MetadataClient())

        branches = _flatten_union(query)
        self.assertEqual(1, len(branches[1].expressions))
        self.assertTrue(branches[1].expressions[0].is_star)

    def test_builder_traces_and_generates_nonfirst_union_star_column(self) -> None:
        result = SingleJobProductionBuilder(
            "hive",
            _MetadataClient(),
        ).build(UNION_STAR_INSERT_SQL, "metric")

        self.assertEqual(
            ["db.current_rows.metric", "db.previous_rows.metric"],
            [item.ref for item in result.trace.value_sources],
        )
        self.assertEqual(2, result.production.union_branch_count)
        self.assertIn("FROM db.previous_rows", result.production.sql)
        self.assertEqual(2, result.production.sql.count("metric"))

    def test_expands_derived_union_stars_by_each_source_output_order(self) -> None:
        result = SingleJobProductionBuilder("hive").build(
            DERIVED_UNION_STAR_INSERT_SQL,
            "query_id",
        )

        self.assertEqual(
            ["db.impala_queries.query_id", "db.leap_queries.tqs_id"],
            [item.ref for item in result.trace.value_sources],
        )
        self.assertEqual(
            ("db.impala_queries.query_id", "db.leap_queries.tqs_id"),
            result.production.value_sources,
        )
        query = sqlglot.parse_one(result.production.sql, read="hive")
        union = next(query.find_all(exp.Union))
        self.assertEqual(
            [["query_id"], ["tqs_id"]],
            [
                [item.alias_or_name for item in branch.expressions]
                for branch in _flatten_union(union)
            ],
        )

    def test_rejects_mismatched_derived_union_star_contracts(self) -> None:
        query = sqlglot.parse_one("""
            WITH left_rows AS (SELECT id, metric FROM db.left_source),
                 right_rows AS (SELECT id FROM db.right_source)
            SELECT * FROM left_rows
            UNION ALL
            SELECT * FROM right_rows
        """, read="hive")

        with self.assertRaisesRegex(
            SqlStructureError,
            "derived UNION SELECT .* branch output counts differ",
        ):
            expand_derived_union_stars(query)

    def test_expands_derived_star_through_single_physical_star_cte(self) -> None:
        result = SingleJobProductionBuilder(
            "hive",
            _MetadataClient(),
        ).build(DERIVED_CTE_PHYSICAL_STAR_INSERT_SQL, "metric")

        self.assertEqual(
            ["db.current_rows.metric", "db.previous_rows.metric"],
            [item.ref for item in result.trace.value_sources],
        )
        self.assertEqual(
            ("db.current_rows.metric", "db.previous_rows.metric"),
            result.production.value_sources,
        )

    def test_expands_outer_leaf_of_three_branch_derived_union(self) -> None:
        query = sqlglot.parse_one("""
            WITH first_rows AS (SELECT id, metric FROM db.first_source),
                 second_rows AS (SELECT id, metric FROM db.second_source),
                 third_rows AS (SELECT id, metric FROM db.third_source)
            SELECT * FROM first_rows
            UNION ALL
            SELECT * FROM second_rows
            UNION ALL
            SELECT * FROM third_rows
        """, read="hive")

        expand_derived_union_stars(query)

        self.assertEqual(
            [2, 2, 2],
            [len(branch.expressions) for branch in _flatten_union(query)],
        )

    def test_expands_derived_star_and_preserves_appended_discriminator(self) -> None:
        query = sqlglot.parse_one("""
            WITH base AS (SELECT id, metric FROM db.source)
            SELECT *, 'first' AS source_type FROM base
            UNION ALL
            SELECT *, 'second' AS source_type FROM base
        """, read="hive")

        expand_derived_union_stars(query)

        self.assertEqual(
            [
                ["id", "metric", "source_type"],
                ["id", "metric", "source_type"],
            ],
            [
                [item.alias_or_name for item in branch.expressions]
                for branch in _flatten_union(query)
            ],
        )


def _flatten_union(expression: exp.Expression) -> list[exp.Select]:
    if isinstance(expression, exp.Union):
        return _flatten_union(expression.this) + _flatten_union(
            expression.expression,
        )
    if not isinstance(expression, exp.Select):
        raise AssertionError(type(expression))
    return [expression]


if __name__ == "__main__":
    unittest.main()
