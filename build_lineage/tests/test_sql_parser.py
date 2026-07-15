from __future__ import annotations

import unittest

from build_lineage.sql_parser import SqlStructureError, SqlStructureParser


class SqlStructureParserTests(unittest.TestCase):
    def setUp(self) -> None:
        self.parser = SqlStructureParser("hive")

    def test_parses_insert_partitions_ctes_and_three_union_branches(self) -> None:
        sql = """
        WITH dates AS (
          SELECT p_date, 1 AS diffdays FROM source.calendar
        ), behavior AS (
          SELECT IF(SUBSTRING(a.active_info, 1 + d.diffdays, 1) > 0, 1, 0)
                   AS is_active,
                 d.p_date AS logymd
          FROM adbi.device_behavior a
          LEFT JOIN dates d ON a.p_date = d.p_date
        )
        INSERT OVERWRITE TABLE mt_ads.target
        PARTITION(logymd, appname)
        SELECT active_cnt, logymd, appname
        FROM (
          SELECT SUM(is_active) AS active_cnt, logymd, 'game' AS appname
          FROM behavior GROUP BY logymd
          UNION ALL
          SELECT 0 AS active_cnt, logymd, 'game' AS appname
          FROM mt_ads.retention_a
          UNION ALL
          SELECT 0 AS active_cnt, logymd, 'game' AS appname
          FROM mt_ads.retention_b
        ) u
        """

        result = self.parser.parse_insert(sql)

        self.assertEqual("mt_ads.target", result.target_table)
        self.assertTrue(result.overwrite)
        self.assertEqual(["dates", "behavior"], result.ctes)
        self.assertEqual(["logymd", "appname"], [p.name for p in result.partitions])
        self.assertTrue(all(p.dynamic for p in result.partitions))
        self.assertEqual(3, len(result.output_columns))
        self.assertFalse(result.output_columns[0].is_partition)
        self.assertTrue(result.output_columns[1].is_partition)
        self.assertEqual(1, len(result.union_groups))
        self.assertEqual(3, result.union_groups[0].branch_count)
        self.assertEqual(
            ("behavior",),
            result.union_groups[0].branches[0].source_relations,
        )
        self.assertEqual(
            ("adbi.device_behavior", "source.calendar"),
            result.union_groups[0].branches[0].resolved_source_datasets,
        )
        self.assertEqual(
            ["adbi.device_behavior", "mt_ads.retention_a", "mt_ads.retention_b", "source.calendar"],
            result.source_datasets,
        )

    def test_static_partition_does_not_consume_select_output(self) -> None:
        result = self.parser.parse_insert("""
            INSERT INTO TABLE db.target PARTITION(logymd='2026-07-15')
            SELECT user_id FROM db.source
        """)

        self.assertFalse(result.partitions[0].dynamic)
        self.assertEqual("'2026-07-15'", result.partitions[0].value_sql)
        self.assertFalse(result.output_columns[0].is_partition)

    def test_rejects_non_insert_statement(self) -> None:
        with self.assertRaisesRegex(SqlStructureError, "expected INSERT"):
            self.parser.parse_insert("SELECT 1")


if __name__ == "__main__":
    unittest.main()
