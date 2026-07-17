from __future__ import annotations

import io
import json
import unittest
from contextlib import redirect_stderr, redirect_stdout
from pathlib import Path
from unittest.mock import MagicMock, patch

from build_lineage.cli import main
from build_lineage.postgres import JobLookupResult, JobRecord


class MultiStatementBuildCliTests(unittest.TestCase):
    @patch("build_lineage.cli.write_production_sql")
    @patch("build_lineage.cli.PostgresJobRepository")
    @patch("build_lineage.cli.PostgresConfig.from_env")
    @patch("build_lineage.cli.TableMetadataClient.from_env")
    def test_business_job_builds_each_producing_insert(
        self,
        metadata_from_env: MagicMock,
        postgres_from_env: MagicMock,
        repository_class: MagicMock,
        write_sql: MagicMock,
    ) -> None:
        jobs = (
            JobRecord(
                "job.42_0",
                "42__0",
                "hive",
                "insert_overwrite",
                """
                INSERT OVERWRITE TABLE dm.target_hdfs
                SELECT metric FROM dm.previous
                """,
            ),
            JobRecord(
                "job.42_1",
                "42__1",
                "hive",
                "insert_overwrite",
                """
                INSERT OVERWRITE TABLE dm.target
                SELECT metric FROM dm.current
                """,
            ),
            JobRecord(
                "job.42_2",
                "42__2",
                "hive",
                "insert_overwrite",
                """
                INSERT OVERWRITE TABLE dm.target
                SELECT metric FROM dm.previous WHERE 1 > 1
                """,
            ),
        )
        repository_class.return_value.find_jobs.return_value = JobLookupResult(
            query="42",
            matches=jobs,
        )
        write_sql.side_effect = lambda sql, path: Path(path)
        output = io.StringIO()

        with redirect_stdout(output):
            exit_code = main([
                "build-production-sql",
                "--job-id",
                "42",
                "--column",
                "metric",
            ])

        self.assertEqual(0, exit_code)
        result = json.loads(output.getvalue())
        self.assertTrue(result["ok"])
        self.assertEqual(2, result["generated_count"])
        self.assertEqual(1, result["skipped_count"])
        self.assertEqual(0, result["failed_count"])
        self.assertEqual(
            ["generated", "generated", "skipped"],
            [item["status"] for item in result["statements"]],
        )
        self.assertEqual(2, write_sql.call_count)

    @patch("build_lineage.cli.write_production_sql")
    @patch("build_lineage.cli.PostgresJobRepository")
    @patch("build_lineage.cli.PostgresConfig.from_env")
    @patch("build_lineage.cli.TableMetadataClient.from_env")
    def test_business_job_skips_select_only_validation_statement(
        self,
        metadata_from_env: MagicMock,
        postgres_from_env: MagicMock,
        repository_class: MagicMock,
        write_sql: MagicMock,
    ) -> None:
        jobs = (
            JobRecord(
                "job.42_0",
                "42__0",
                "hive",
                "insert_overwrite",
                "INSERT OVERWRITE TABLE dm.target SELECT metric FROM dm.source",
            ),
            JobRecord(
                "job.42_1",
                "42__1",
                "hive",
                "select_only",
                "SELECT COUNT(*) FROM dm.target",
            ),
        )
        repository_class.return_value.find_jobs.return_value = JobLookupResult(
            query="42",
            matches=jobs,
        )
        write_sql.side_effect = lambda sql, path: Path(path)
        output = io.StringIO()

        with redirect_stdout(output):
            exit_code = main([
                "build-production-sql",
                "--job-id",
                "42",
                "--column",
                "metric",
            ])

        self.assertEqual(0, exit_code)
        result = json.loads(output.getvalue())
        self.assertTrue(result["ok"])
        self.assertEqual(1, result["generated_count"])
        self.assertEqual(1, result["skipped_count"])
        self.assertEqual(0, result["failed_count"])
        skipped = result["statements"][1]
        self.assertEqual("job.42_1", skipped["job_id"])
        self.assertEqual(1, skipped["statement_index"])
        self.assertEqual("select_only", skipped["statement_role"])
        self.assertEqual("skipped", skipped["status"])
        self.assertIn("validation SELECT", skipped["reason"])

    @patch("build_lineage.cli.write_production_sql")
    @patch("build_lineage.cli.PostgresJobRepository")
    @patch("build_lineage.cli.PostgresConfig.from_env")
    @patch("build_lineage.cli.TableMetadataClient.from_env")
    def test_business_job_aggregates_non_select_parse_failure(
        self,
        metadata_from_env: MagicMock,
        postgres_from_env: MagicMock,
        repository_class: MagicMock,
        write_sql: MagicMock,
    ) -> None:
        jobs = (
            JobRecord(
                "job.42_0",
                "42__0",
                "hive",
                "insert_overwrite",
                "INSERT OVERWRITE TABLE dm.target SELECT metric FROM dm.source",
            ),
            JobRecord(
                "job.42_1",
                "42__1",
                "hive",
                "insert_overwrite",
                "SELECT metric FROM dm.source",
            ),
        )
        repository_class.return_value.find_jobs.return_value = JobLookupResult(
            query="42",
            matches=jobs,
        )
        write_sql.side_effect = lambda sql, path: Path(path)
        errors = io.StringIO()

        with redirect_stderr(errors):
            exit_code = main([
                "build-production-sql",
                "--job-id",
                "42",
                "--column",
                "metric",
            ])

        self.assertEqual(1, exit_code)
        result = json.loads(errors.getvalue())
        self.assertFalse(result["ok"])
        self.assertEqual(1, result["generated_count"])
        self.assertEqual(1, result["failed_count"])
        failed = result["statements"][1]
        self.assertEqual("job.42_1", failed["job_id"])
        self.assertEqual(1, failed["statement_index"])
        self.assertEqual("unknown", failed["statement_role"])
        self.assertEqual("failed", failed["status"])
        self.assertEqual("SqlStructureError", failed["error_type"])


if __name__ == "__main__":
    unittest.main()
