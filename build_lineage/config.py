from __future__ import annotations

import os
import re
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv
from psycopg2.extensions import make_dsn


PROJECT_ROOT = Path(__file__).resolve().parent.parent
SAFE_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


@dataclass(frozen=True)
class PostgresConfig:
    dsn: str
    schema: str = "lineage"

    def __post_init__(self) -> None:
        if not self.dsn.strip():
            raise ValueError("PostgreSQL DSN must not be empty")
        if not SAFE_IDENTIFIER.fullmatch(self.schema):
            raise ValueError(f"Unsafe PostgreSQL schema name: {self.schema!r}")

    @classmethod
    def from_env(cls) -> "PostgresConfig":
        env_file = Path(
            os.environ.get("BIRAG_ENV_FILE", PROJECT_ROOT / ".env")
        ).expanduser()
        load_dotenv(env_file, override=False)

        dsn = os.environ.get("BIRAG_PG_DSN")
        if not dsn:
            dsn = make_dsn(
                host=os.environ.get("BIRAG_PG_HOST", "localhost"),
                port=os.environ.get("BIRAG_PG_PORT", "5432"),
                dbname=os.environ.get("BIRAG_PG_DB", "metadata_kb"),
                user=os.environ.get("BIRAG_PG_USER", "postgres"),
                password=os.environ.get("BIRAG_PG_PASSWORD", ""),
            )
        return cls(
            dsn=dsn,
            schema=os.environ.get("BIRAG_LINEAGE_SCHEMA", "lineage"),
        )

