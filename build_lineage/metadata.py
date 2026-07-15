from __future__ import annotations

import json
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Callable
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

from dotenv import load_dotenv

from .config import PROJECT_ROOT


DEFAULT_TABLE_METADATA_URL = (
    "http://fons-dev.test.bi.moontontech.net/metadata/metadata/tables/by-name"
)


class MetadataServiceError(ValueError):
    """The metadata service could not return a usable table schema."""


@dataclass(frozen=True)
class MetadataColumn:
    name: str
    type: str
    position: int
    comment: str | None
    is_partition_key: bool
    nullable: bool | None

    def to_dict(self) -> dict[str, object]:
        return {
            "name": self.name,
            "type": self.type,
            "position": self.position,
            "comment": self.comment,
            "is_partition_key": self.is_partition_key,
            "is_nullable": self.nullable,
        }


@dataclass(frozen=True)
class TableMetadata:
    database_name: str
    table_name: str
    full_table_name: str
    description: str | None
    table_type: str | None
    columns: tuple[MetadataColumn, ...]

    @property
    def data_columns(self) -> tuple[MetadataColumn, ...]:
        return tuple(sorted(
            (column for column in self.columns if not column.is_partition_key),
            key=lambda column: column.position,
        ))

    @property
    def partition_columns(self) -> tuple[MetadataColumn, ...]:
        return tuple(sorted(
            (column for column in self.columns if column.is_partition_key),
            key=lambda column: column.position,
        ))

    def to_dict(self) -> dict[str, object]:
        return {
            "database_name": self.database_name,
            "table_name": self.table_name,
            "full_table_name": self.full_table_name,
            "description": self.description,
            "table_type": self.table_type,
            "column_count": len(self.columns),
            "data_columns": [column.to_dict() for column in self.data_columns],
            "partition_columns": [
                column.to_dict() for column in self.partition_columns
            ],
        }


class TableMetadataClient:
    def __init__(
        self,
        endpoint: str = DEFAULT_TABLE_METADATA_URL,
        timeout: float = 10.0,
        *,
        opener: Callable[..., Any] = urlopen,
    ) -> None:
        if not endpoint.strip():
            raise ValueError("metadata endpoint must not be empty")
        if timeout <= 0:
            raise ValueError("metadata timeout must be positive")
        self.endpoint = endpoint
        self.timeout = timeout
        self._opener = opener
        self._cache: dict[tuple[str, str], TableMetadata] = {}

    @classmethod
    def from_env(cls) -> "TableMetadataClient":
        env_file = Path(
            os.environ.get("BIRAG_ENV_FILE", PROJECT_ROOT / ".env")
        ).expanduser()
        load_dotenv(env_file, override=False)
        return cls(
            endpoint=os.environ.get(
                "BIRAG_TABLE_METADATA_URL",
                DEFAULT_TABLE_METADATA_URL,
            ),
            timeout=float(os.environ.get("BIRAG_METADATA_TIMEOUT", "10")),
        )

    def get_table(self, database_name: str, table_name: str) -> TableMetadata:
        database_name = database_name.strip()
        table_name = table_name.strip()
        if not database_name or not table_name:
            raise ValueError("database name and table name must not be empty")
        cache_key = (database_name.lower(), table_name.lower())
        cached = self._cache.get(cache_key)
        if cached is not None:
            return cached

        separator = "&" if "?" in self.endpoint else "?"
        url = self.endpoint + separator + urlencode({
            "databaseName": database_name,
            "tableName": table_name,
        })
        request = Request(url, headers={"Accept": "application/json"})
        try:
            with self._opener(request, timeout=self.timeout) as response:
                payload = json.loads(response.read().decode("utf-8"))
        except HTTPError as error:
            raise MetadataServiceError(
                f"metadata request failed with HTTP {error.code}: "
                f"{database_name}.{table_name}"
            ) from error
        except URLError as error:
            raise MetadataServiceError(
                f"metadata request failed for {database_name}.{table_name}: "
                f"{error.reason}"
            ) from error
        except TimeoutError as error:
            raise MetadataServiceError(
                f"metadata request timed out for {database_name}.{table_name}"
            ) from error
        except (UnicodeDecodeError, json.JSONDecodeError) as error:
            raise MetadataServiceError(
                f"metadata response is not valid JSON: {database_name}.{table_name}"
            ) from error

        result = _parse_table_metadata(payload, database_name, table_name)
        self._cache[cache_key] = result
        return result

    def get_table_by_name(self, full_table_name: str) -> TableMetadata:
        parts = [part for part in full_table_name.strip().split(".") if part]
        if len(parts) != 2:
            raise ValueError("table name must have the form database.table")
        return self.get_table(parts[0], parts[1])


def _parse_table_metadata(
    payload: object,
    expected_database: str,
    expected_table: str,
) -> TableMetadata:
    if not isinstance(payload, dict):
        raise MetadataServiceError("metadata response must be a JSON object")
    if payload.get("code") != 0:
        message = payload.get("message") or "unknown service error"
        raise MetadataServiceError(f"metadata service error: {message}")
    data = payload.get("data")
    if not isinstance(data, dict):
        raise MetadataServiceError(
            f"metadata table not found: {expected_database}.{expected_table}"
        )
    raw_columns = data.get("columns")
    if not isinstance(raw_columns, list):
        raise MetadataServiceError("metadata response has no columns array")

    columns: list[MetadataColumn] = []
    for index, item in enumerate(raw_columns, start=1):
        if not isinstance(item, dict) or not str(item.get("name") or "").strip():
            raise MetadataServiceError(f"metadata column {index} has no name")
        try:
            position = int(item.get("position"))
        except (TypeError, ValueError) as error:
            raise MetadataServiceError(
                f"metadata column {item.get('name')!r} has invalid position"
            ) from error
        if position < 1:
            raise MetadataServiceError(
                f"metadata column {item.get('name')!r} has invalid position"
            )
        nullable = item.get("is_nullable")
        columns.append(MetadataColumn(
            name=str(item["name"]),
            type=str(item.get("type") or item.get("data_type") or "unknown"),
            position=position,
            comment=item.get("comment"),
            is_partition_key=bool(item.get("is_partition_key")),
            nullable=nullable if isinstance(nullable, bool) else None,
        ))

    for group_name, group in (
        ("data", [column for column in columns if not column.is_partition_key]),
        ("partition", [column for column in columns if column.is_partition_key]),
    ):
        positions = [column.position for column in group]
        if len(positions) != len(set(positions)):
            raise MetadataServiceError(
                f"metadata {group_name} columns contain duplicate positions"
            )

    database_name = str(data.get("databaseName") or expected_database)
    table_name = str(data.get("tableName") or expected_table)
    return TableMetadata(
        database_name=database_name,
        table_name=table_name,
        full_table_name=str(
            data.get("fullTableName") or f"{database_name}.{table_name}"
        ),
        description=data.get("description"),
        table_type=data.get("tableType"),
        columns=tuple(columns),
    )
