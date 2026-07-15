from __future__ import annotations

import io
import json
import unittest

from build_lineage.metadata import MetadataServiceError, TableMetadataClient


class _Response(io.BytesIO):
    def __enter__(self) -> "_Response":
        return self

    def __exit__(self, *args: object) -> None:
        self.close()


class TableMetadataClientTests(unittest.TestCase):
    def test_reads_data_and_partition_column_positions(self) -> None:
        calls = []

        def opener(request, *, timeout):
            calls.append((request.full_url, timeout, request.headers))
            payload = {
                "code": 0,
                "data": {
                    "databaseName": "db",
                    "tableName": "target",
                    "fullTableName": "db.target",
                    "tableType": "external_table",
                    "columns": [
                        {
                            "name": "metric",
                            "type": "bigint",
                            "comment": "指标",
                            "position": 2,
                            "is_partition_key": False,
                            "is_nullable": True,
                        },
                        {
                            "name": "user_id",
                            "type": "string",
                            "position": 1,
                            "is_partition_key": False,
                        },
                        {
                            "name": "logymd",
                            "type": "string",
                            "position": 1,
                            "is_partition_key": True,
                        },
                    ],
                },
            }
            return _Response(json.dumps(payload).encode())

        client = TableMetadataClient(
            "http://metadata.test/tables/by-name",
            timeout=3,
            opener=opener,
        )
        table = client.get_table_by_name("db.target")
        cached = client.get_table_by_name("DB.TARGET")

        self.assertIs(table, cached)
        self.assertEqual(["user_id", "metric"], [c.name for c in table.data_columns])
        self.assertEqual(["logymd"], [c.name for c in table.partition_columns])
        self.assertEqual(1, len(calls))
        self.assertIn("databaseName=db", calls[0][0])
        self.assertIn("tableName=target", calls[0][0])
        self.assertEqual(3, calls[0][1])

    def test_rejects_service_error(self) -> None:
        def opener(request, *, timeout):
            return _Response(json.dumps({
                "code": 404,
                "data": None,
                "message": "not found",
            }).encode())

        client = TableMetadataClient("http://metadata.test", opener=opener)
        with self.assertRaisesRegex(MetadataServiceError, "not found"):
            client.get_table_by_name("db.missing")


if __name__ == "__main__":
    unittest.main()
