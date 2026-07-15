from __future__ import annotations

import unittest

from build_lineage.postgres import JobRecord
from build_lineage.statements import classify_statement, job_identity


class StatementClassificationTests(unittest.TestCase):
    def test_extracts_business_job_and_statement_index(self) -> None:
        self.assertEqual(("100000993", 2), job_identity("job.100000993_2"))
        self.assertEqual(("custom_name", 12), job_identity("job.custom_name_12"))

    def test_classifies_static_false_overwrite_as_empty(self) -> None:
        job = JobRecord(
            "job.100000993_2",
            "100000993__2",
            "hive",
            "insert_overwrite",
            """
            INSERT OVERWRITE TABLE dm.target PARTITION(logymd='2026-05-24')
            SELECT metric FROM dm.snapshot
            WHERE logymd = '1970-01-01' AND 1 > 1
            """,
        )

        result = classify_statement(job)

        self.assertEqual("empty_overwrite", result.role)
        self.assertFalse(result.produces_rows)
        self.assertEqual("100000993", result.business_job_id)
        self.assertEqual(2, result.statement_index)

    def test_classifies_single_source_hdfs_write_as_snapshot(self) -> None:
        job = JobRecord(
            "job.100000993_0",
            "100000993__0",
            "hive",
            "insert_overwrite",
            """
            INSERT OVERWRITE TABLE dm.target_hdfs PARTITION(logymd='2026-05-30')
            SELECT metric FROM dm.target WHERE logymd='2026-05-30'
            """,
        )

        result = classify_statement(job)

        self.assertEqual("snapshot_copy", result.role)
        self.assertTrue(result.produces_rows)

    def test_defaults_to_data_write(self) -> None:
        job = JobRecord(
            "job.100000993_1",
            "100000993__1",
            "hive",
            "insert_overwrite",
            "INSERT OVERWRITE TABLE dm.target SELECT metric FROM dm.source",
        )

        self.assertEqual("data_write", classify_statement(job).role)


if __name__ == "__main__":
    unittest.main()
