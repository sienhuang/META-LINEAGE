from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from build_lineage.column_tracer import SingleJobColumnTracer
from build_lineage.document import (
    build_column_logic_document,
    write_column_logic_document,
)
from build_lineage.postgres import JobRecord
from build_lineage.tests.test_column_tracer import SQL


class ColumnLogicDocumentTests(unittest.TestCase):
    def test_builds_readable_single_job_document(self) -> None:
        job = JobRecord(
            "job.100021029_0",
            "100021029__0",
            "hive",
            "insert_overwrite",
            SQL,
        )
        trace = SingleJobColumnTracer("hive").trace(SQL, "active_cnt")

        document = build_column_logic_document(job, trace)

        self.assertEqual("1.0", document["schema_version"])
        self.assertEqual("single_job", document["scope"])
        self.assertTrue(document["complete"])
        self.assertEqual(
            "mt_ads.target.active_cnt",
            document["target"]["ref"],
        )
        self.assertEqual(
            ["adbi.device_behavior.active_info"],
            document["value_sources"],
        )
        self.assertEqual(3, len(document["production_logic"]["branches"]))
        self.assertNotIn("trace", document)

    def test_writes_valid_utf8_json(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "nested" / "column_logic.json"
            written = write_column_logic_document(
                {"description": "活跃玩家数"},
                output,
            )

            self.assertEqual(output.resolve(), written)
            self.assertEqual(
                "活跃玩家数",
                json.loads(output.read_text(encoding="utf-8"))["description"],
            )
            self.assertFalse(output.with_suffix(".json.tmp").exists())


if __name__ == "__main__":
    unittest.main()
