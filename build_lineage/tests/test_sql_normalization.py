from __future__ import annotations

import unittest

import sqlglot
from sqlglot import exp

from build_lineage.builder import SingleJobProductionBuilder
from build_lineage.sql_normalization import protect_lateral_explode_columns
from build_lineage.sql_normalization import (
    qualify_metadata_unique_columns,
    qualify_single_source_shadowed_columns,
)
from build_lineage.metadata import MetadataColumn, TableMetadata


LATERAL_INSERT_SQL = """
WITH base AS (
  SELECT zoneid, items
  FROM db.raw_events
), expanded AS (
  SELECT zoneid
  FROM base
  LATERAL VIEW EXPLODE(items) exploded AS item
)
INSERT OVERWRITE TABLE db.target
SELECT zoneid FROM expanded
"""


QUALIFIED_LATERAL_INPUT_SQL = """
WITH base AS (
  SELECT zoneid, ri_chessinfo
  FROM db.raw_events
)
INSERT OVERWRITE TABLE db.target
SELECT r.zoneid AS zoneid
FROM base r
LATERAL VIEW EXPLODE(SPLIT(r.ri_chessinfo, ';')) exploded AS item
"""


SHADOWED_INPUT_SQL = """
WITH base AS (
  SELECT campaign_name, fb_campaign_name, use_fb
  FROM db.events
)
INSERT OVERWRITE TABLE db.target
SELECT IF(use_fb, fb_campaign_name, campaign_name) AS campaign_name,
       REGEXP_EXTRACT(campaign_name, '(\\\\d+)') AS campaign_id
FROM base t1
"""


class LateralExplodeNormalizationTests(unittest.TestCase):
    def test_wraps_only_direct_column_lateral_explode_inputs(self) -> None:
        query = sqlglot.parse_one("""
            SELECT zoneid
            FROM db.events
            LATERAL VIEW EXPLODE(items) direct_items AS item
            LATERAL VIEW EXPLODE(SPLIT(tags, ',')) split_tags AS tag
        """, read="hive")

        changed = protect_lateral_explode_columns(query)

        laterals = list(query.find_all(exp.Lateral))
        self.assertEqual(1, changed)
        self.assertIsInstance(laterals[0].this.this, exp.Paren)
        self.assertIsInstance(laterals[1].this.this, exp.RegexpSplit)

    def test_is_idempotent(self) -> None:
        query = sqlglot.parse_one(
            "SELECT item FROM db.events "
            "LATERAL VIEW EXPLODE(items) exploded AS item",
            read="hive",
        )

        self.assertEqual(1, protect_lateral_explode_columns(query))
        self.assertEqual(0, protect_lateral_explode_columns(query))

    def test_builder_preserves_physical_source_and_validates_output(self) -> None:
        result = SingleJobProductionBuilder("hive").build(
            LATERAL_INSERT_SQL,
            "zoneid",
        )

        self.assertEqual(
            ["db.raw_events.zoneid"],
            [source.ref for source in result.trace.value_sources],
        )
        self.assertTrue(result.production.validated)
        self.assertEqual(("db.raw_events.zoneid",), result.production.value_sources)

    def test_pruning_preserves_columns_used_by_lateral_input(self) -> None:
        result = SingleJobProductionBuilder("hive").build(
            QUALIFIED_LATERAL_INPUT_SQL,
            "zoneid",
        )

        self.assertTrue(result.production.validated)
        self.assertIn("ri_chessinfo", result.production.sql)
        self.assertEqual(
            ("db.raw_events.zoneid",),
            result.production.value_sources,
        )


class ShadowedColumnNormalizationTests(unittest.TestCase):
    def test_builder_uses_single_input_column_not_sibling_alias(self) -> None:
        result = SingleJobProductionBuilder("hive").build(
            SHADOWED_INPUT_SQL,
            "campaign_id",
        )

        self.assertEqual(
            ["db.events.campaign_name"],
            [source.ref for source in result.trace.value_sources],
        )
        self.assertEqual(
            ("db.events.campaign_name",),
            result.production.value_sources,
        )
        self.assertIn("t1.campaign_name", result.production.sql)

    def test_leaves_multi_source_shadowed_name_unqualified(self) -> None:
        query = sqlglot.parse_one("""
            SELECT metric AS metric, metric + 1 AS next_metric
            FROM db.left_source l
            JOIN db.right_source r ON l.id = r.id
        """, read="hive")

        changed = qualify_single_source_shadowed_columns(query)

        next_metric = query.selects[1]
        metric = next(next_metric.find_all(exp.Column))
        self.assertEqual(0, changed)
        self.assertEqual("", metric.table)


class _UniqueColumnMetadataClient:
    def __init__(self, both_have_time: bool = False) -> None:
        self.both_have_time = both_have_time

    def get_table(self, database_name: str, table_name: str) -> TableMetadata:
        names = {
            "events": ("id", "time", "metric"),
            "users": ("id", "time") if self.both_have_time else ("id",),
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


class MetadataUniqueColumnNormalizationTests(unittest.TestCase):
    def test_qualifies_projection_column_proven_to_one_join_source(self) -> None:
        query = sqlglot.parse_one("""
            SELECT MIN(UNIX_TIMESTAMP(`time`) + a.metric) AS metric
            FROM db.events a
            JOIN db.users b ON a.id = b.id
        """, read="hive")

        changed = qualify_metadata_unique_columns(
            query,
            _UniqueColumnMetadataClient(),
        )

        time_column = next(
            column for column in query.find_all(exp.Column)
            if column.name == "time"
        )
        self.assertEqual(1, changed)
        self.assertEqual("a", time_column.table)

    def test_leaves_column_unqualified_when_two_sources_contain_it(self) -> None:
        query = sqlglot.parse_one("""
            SELECT UNIX_TIMESTAMP(`time`) AS event_time
            FROM db.events a
            JOIN db.users b ON a.id = b.id
        """, read="hive")

        changed = qualify_metadata_unique_columns(
            query,
            _UniqueColumnMetadataClient(both_have_time=True),
        )

        time_column = next(
            column for column in query.find_all(exp.Column)
            if column.name == "time"
        )
        self.assertEqual(0, changed)
        self.assertEqual("", time_column.table)


if __name__ == "__main__":
    unittest.main()
