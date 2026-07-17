from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path


MODULE_PATH = Path(__file__).with_name("failure_queue.py")
SPEC = importlib.util.spec_from_file_location("failure_queue", MODULE_PATH)
assert SPEC and SPEC.loader
failure_queue = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(failure_queue)


class FailureQueueTest(unittest.TestCase):
    def test_unresolved_is_handled_and_reported_unsuccessful(self) -> None:
        failures = [
            {"job_id": "job.1_0", "column": "a", "phase": "build"},
            {"job_id": "job.2_0", "column": "b", "phase": "build"},
        ]
        states = [
            {
                **failures[0],
                "status": "unresolved",
                "recorded_at": "2026-07-16T00:00:00+00:00",
            }
        ]

        summary = failure_queue._summary(failures, states)

        self.assertEqual(summary["pending"], 1)
        self.assertEqual(summary["handled"], 1)
        self.assertEqual(summary["verified"], 0)
        self.assertEqual(summary["unsuccessful"], 1)
        self.assertEqual(failure_queue._next(failures, states)["next"], failures[1])

    def test_sync_case_file_is_idempotent(self) -> None:
        event = {
            "job_id": "job.1_0",
            "column": "a",
            "phase": "build",
            "status": "verified",
            "recorded_at": "2026-07-16T00:00:00+00:00",
        }
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "verified_cases.jsonl"
            self.assertEqual(failure_queue._sync_case_file(path, [event]), 1)
            self.assertEqual(failure_queue._sync_case_file(path, [event]), 0)
            self.assertEqual(failure_queue._read_jsonl(path), [event])


if __name__ == "__main__":
    unittest.main()
