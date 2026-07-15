from __future__ import annotations

import os
import unittest
from unittest.mock import MagicMock, patch

from build_lineage.config import PostgresConfig
from build_lineage.postgres import JobRecord, PostgresJobRepository


class PostgresConfigTests(unittest.TestCase):
    def test_builds_config_from_individual_environment_values(self) -> None:
        env = {
            "BIRAG_PG_HOST": "db.internal",
            "BIRAG_PG_PORT": "5433",
            "BIRAG_PG_DB": "lineage_db",
            "BIRAG_PG_USER": "reader",
            "BIRAG_PG_PASSWORD": "secret with spaces",
            "BIRAG_LINEAGE_SCHEMA": "custom_lineage",
        }
        with patch.dict(os.environ, env, clear=True):
            config = PostgresConfig.from_env()

        self.assertIn("host=db.internal", config.dsn)
        self.assertIn("password='secret with spaces'", config.dsn)
        self.assertEqual("custom_lineage", config.schema)

    def test_rejects_unsafe_schema(self) -> None:
        with self.assertRaises(ValueError):
            PostgresConfig(dsn="dbname=test", schema="lineage; drop schema")


class JobRecordTests(unittest.TestCase):
    def test_hides_sql_by_default(self) -> None:
        record = JobRecord("job.1_0", "1__0", "hive", "insert", "select 1")

        value = record.to_dict()

        self.assertNotIn("raw_sql", value)
        self.assertEqual(8, value["raw_sql_length"])


class PostgresJobRepositoryTests(unittest.TestCase):
    @patch("build_lineage.postgres.psycopg2.connect")
    def test_business_job_id_finds_stored_instance(self, connect: MagicMock) -> None:
        cursor = connect.return_value.__enter__.return_value.cursor.return_value
        cursor.__enter__.return_value.fetchall.return_value = [
            ("job.100021029_0", "100021029__0", "hive", "insert", "select 1")
        ]
        repository = PostgresJobRepository(
            PostgresConfig(dsn="dbname=test", schema="lineage")
        )

        result = repository.find_jobs("100021029")

        self.assertTrue(result.unique)
        self.assertEqual("job.100021029_0", result.matches[0].job_id)
        parameters = cursor.__enter__.return_value.execute.call_args.args[1]
        self.assertEqual("job.100021029\\_%", parameters[2])


if __name__ == "__main__":
    unittest.main()
