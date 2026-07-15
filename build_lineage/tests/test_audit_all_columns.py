from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from build_lineage.audit_all_columns import AuditOptions, ProductionSqlAuditor
from build_lineage.postgres import JobRecord
from build_lineage.tests.test_column_tracer import SQL


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


if __name__ == "__main__":
    unittest.main()
