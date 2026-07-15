from __future__ import annotations

import unittest

import sqlglot
from sqlglot import exp

from build_lineage.builder import SingleJobProductionBuilder
from build_lineage.metadata import MetadataColumn, TableMetadata
from build_lineage.sql_parser import SqlStructureError
from build_lineage.union_star import expand_simple_union_stars


UNION_STAR_INSERT_SQL = """
INSERT OVERWRITE TABLE db.target PARTITION(logymd, app_id)
SELECT id, metric, '2026-07-15' AS logymd, app_id
FROM db.current_rows
UNION ALL
SELECT *
FROM db.previous_rows
WHERE logymd = '2026-07-14'
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
