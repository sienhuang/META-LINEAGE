from __future__ import annotations

import io
import json
import logging
import tempfile
import unittest
from contextlib import redirect_stderr
from pathlib import Path

from build_lineage.audit_all_columns import AuditOptions, ProductionSqlAuditor
from build_lineage.postgres import JobRecord
from build_lineage.tests.test_column_tracer import (
    SQL,
    UNALIASED_INSERT_SQL,
    _MetadataClient,
)


class ProductionSqlAuditorTests(unittest.TestCase):
    def test_writes_success_failure_group_table_and_summary_reports(self) -> None:
        jobs = [
            JobRecord(
                "job.good_0",
                "good__0",
                "hive",
                "insert_overwrite",
                SQL,
            ),
            JobRecord(
                "job.bad_0",
                "bad__0",
                "hive",
                "unknown",
                "SELECT 1",
            ),
        ]
        with tempfile.TemporaryDirectory() as directory:
            report_dir = Path(directory) / "audit"
            summary = ProductionSqlAuditor(AuditOptions(
                report_dir=report_dir,
                progress_every=1,
            )).run(jobs)

            self.assertEqual(2, summary["counts"]["jobs_seen"])
            self.assertEqual(1, summary["counts"]["jobs_parsed"])
            self.assertEqual(1, summary["counts"]["jobs_failed"])
            self.assertEqual(1, summary["counts"]["columns_attempted"])
            self.assertEqual(1, summary["counts"]["columns_succeeded"])
            self.assertEqual(0, summary["counts"]["columns_failed"])
            self.assertEqual(1, summary["issues_total"])
            self.assertEqual(0, summary["columns_not_attempted"])
            failures = [
                json.loads(line)
                for line in (report_dir / "failures.jsonl").read_text().splitlines()
            ]
            self.assertEqual("parse_job", failures[0]["phase"])
            groups = json.loads(
                (report_dir / "failure_groups.json").read_text()
            )
            self.assertEqual(1, groups[0]["count"])
            tables = json.loads((report_dir / "tables.json").read_text())
            self.assertEqual("mt_ads.target", tables[0]["target_table"])
            successes = [
                json.loads(line)
                for line in (report_dir / "successes.jsonl").read_text().splitlines()
            ]
            self.assertEqual("active_cnt", successes[0]["column"])

    def test_groups_multi_statement_task_and_skips_empty_overwrite(self) -> None:
        jobs = [
            JobRecord(
                "job.100000993_0",
                "100000993__0",
                "hive",
                "insert_overwrite",
                """
                INSERT OVERWRITE TABLE dm.target_hdfs
                PARTITION(logymd='2026-05-30')
                SELECT metric FROM dm.target WHERE logymd='2026-05-30'
                """,
            ),
            JobRecord(
                "job.100000993_1",
                "100000993__1",
                "hive",
                "insert_overwrite",
                """
                INSERT OVERWRITE TABLE dm.target
                PARTITION(logymd='2026-05-31')
                SELECT metric FROM dm.daily
                """,
            ),
            JobRecord(
                "job.100000993_2",
                "100000993__2",
                "hive",
                "insert_overwrite",
                """
                INSERT OVERWRITE TABLE dm.target
                PARTITION(logymd='2026-05-24')
                SELECT metric FROM dm.target_hdfs WHERE 1 > 1
                """,
            ),
        ]
        with tempfile.TemporaryDirectory() as directory:
            report_dir = Path(directory) / "audit"
            summary = ProductionSqlAuditor(AuditOptions(
                report_dir=report_dir,
                progress_every=1,
            )).run(jobs)

            self.assertEqual(3, summary["counts"]["jobs_seen"])
            self.assertEqual(1, summary["counts"]["business_tasks"])
            self.assertEqual(1, summary["counts"]["multi_statement_tasks"])
            self.assertEqual(1, summary["counts"]["empty_overwrites"])
            self.assertEqual(1, summary["counts"]["statements_skipped"])
            self.assertEqual(2, summary["counts"]["columns_attempted"])
            tasks = json.loads((report_dir / "tasks.json").read_text())
            self.assertEqual(1, len(tasks))
            self.assertEqual(3, tasks[0]["statement_count"])
            self.assertEqual(
                {
                    "data_write": 1,
                    "empty_overwrite": 1,
                    "snapshot_copy": 1,
                },
                tasks[0]["statement_role_counts"],
            )
            self.assertEqual(
                "skipped_empty_overwrite",
                tasks[0]["statements"][2]["audit_status"],
            )

    def test_uses_shared_schema_resolution_for_anonymous_outputs(self) -> None:
        class LoggingMetadataClient(_MetadataClient):
            def get_table_by_name(self, table_name):
                logging.getLogger("sqlglot").warning(
                    "Invalid JSON path syntax. test warning"
                )
                return super().get_table_by_name(table_name)

        job = JobRecord(
            "job.schema_0",
            "schema__0",
            "hive",
            "insert_overwrite",
            UNALIASED_INSERT_SQL,
        )
        with tempfile.TemporaryDirectory() as directory:
            report_dir = Path(directory) / "audit"
            stderr = io.StringIO()
            with redirect_stderr(stderr):
                summary = ProductionSqlAuditor(
                    AuditOptions(report_dir=report_dir),
                    metadata_client=LoggingMetadataClient(),
                ).run([job])

            self.assertEqual(2, summary["counts"]["columns_discovered"])
            self.assertEqual(2, summary["counts"]["columns_succeeded"])
            self.assertEqual(0, summary["counts"]["columns_failed"])
            successes = [
                json.loads(line)
                for line in (report_dir / "successes.jsonl").read_text().splitlines()
            ]
            self.assertEqual(
                ["user_id", "login_cnt"],
                [item["column"] for item in successes],
            )
            self.assertNotIn("Invalid JSON path", stderr.getvalue())
            diagnostics = [
                json.loads(line)
                for line in (report_dir / "diagnostics.jsonl").read_text().splitlines()
            ]
            self.assertGreaterEqual(len(diagnostics), 1)
            self.assertEqual("job.schema_0", diagnostics[0]["job_id"])
            self.assertEqual("inspect_insert", diagnostics[0]["phase"])
            self.assertIn("Invalid JSON path", diagnostics[0]["message"])
            self.assertEqual(len(diagnostics), summary["counts"]["diagnostic_events"])


if __name__ == "__main__":
    unittest.main()
