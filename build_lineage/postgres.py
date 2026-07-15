from __future__ import annotations

from dataclasses import asdict, dataclass
from collections.abc import Iterator
from typing import Any

import psycopg2
from psycopg2 import sql

from .config import PostgresConfig


@dataclass(frozen=True)
class JobRecord:
    job_id: str
    job_name: str
    engine: str
    write_mode: str
    raw_sql: str

    def to_dict(self, *, include_sql: bool = False) -> dict[str, Any]:
        value = asdict(self)
        raw_sql = value.pop("raw_sql")
        value["raw_sql_length"] = len(raw_sql)
        if include_sql:
            value["raw_sql"] = raw_sql
        return value


@dataclass(frozen=True)
class JobLookupResult:
    query: str
    matches: tuple[JobRecord, ...]

    @property
    def found(self) -> bool:
        return bool(self.matches)

    @property
    def unique(self) -> bool:
        return len(self.matches) == 1


class PostgresJobRepository:
    """Read raw jobs without depending on the legacy lineage package."""

    def __init__(self, config: PostgresConfig) -> None:
        self.config = config

    def connect(self):
        return psycopg2.connect(self.config.dsn)

    def check_connection(self) -> dict[str, Any]:
        with self.connect() as connection:
            with connection.cursor() as cursor:
                cursor.execute(
                    "select current_database(), current_user, version()"
                )
                database, user, version = cursor.fetchone()
                cursor.execute(
                    """
                    select exists (
                        select 1
                        from information_schema.tables
                        where table_schema = %s and table_name = 'job'
                    )
                    """,
                    (self.config.schema,),
                )
                job_table_exists = bool(cursor.fetchone()[0])
                job_count = None
                if job_table_exists:
                    cursor.execute(
                        sql.SQL("select count(*) from {}.{}").format(
                            sql.Identifier(self.config.schema),
                            sql.Identifier("job"),
                        )
                    )
                    job_count = int(cursor.fetchone()[0])
        return {
            "connected": True,
            "database": database,
            "user": user,
            "server": version.split(",", 1)[0],
            "schema": self.config.schema,
            "job_table_exists": job_table_exists,
            "job_count": job_count,
        }

    def find_jobs(self, job_ref: str) -> JobLookupResult:
        job_ref = job_ref.strip()
        if not job_ref:
            raise ValueError("job reference must not be empty")

        table = sql.SQL("{}.{}").format(
            sql.Identifier(self.config.schema),
            sql.Identifier("job"),
        )
        statement = sql.SQL(
            """
            select job_id, job_name, engine, write_mode, raw_sql
            from {}
            where job_id = %s
               or job_name = %s
               or job_id like %s escape '\\'
            order by job_id
            """
        ).format(table)
        instance_pattern = f"job.{_escape_like(job_ref)}\\_%"

        with self.connect() as connection:
            with connection.cursor() as cursor:
                cursor.execute(statement, (job_ref, job_ref, instance_pattern))
                rows = cursor.fetchall()
        matches = tuple(JobRecord(*row) for row in rows)
        return JobLookupResult(query=job_ref, matches=matches)

    def iter_jobs(
        self,
        *,
        limit: int | None = None,
        offset: int = 0,
        fetch_size: int = 50,
    ) -> Iterator[JobRecord]:
        if limit is not None and limit < 1:
            raise ValueError("limit must be >= 1")
        if offset < 0:
            raise ValueError("offset must be >= 0")
        if fetch_size < 1:
            raise ValueError("fetch_size must be >= 1")

        table = sql.SQL("{}.{}").format(
            sql.Identifier(self.config.schema),
            sql.Identifier("job"),
        )
        statement = sql.SQL(
            """
            select job_id, job_name, engine, write_mode, raw_sql
            from {}
            order by job_id
            """
        ).format(table)
        parameters: list[int] = []
        if limit is not None:
            statement += sql.SQL(" limit %s")
            parameters.append(limit)
        statement += sql.SQL(" offset %s")
        parameters.append(offset)

        with self.connect() as connection:
            with connection.cursor(name="build_lineage_job_stream") as cursor:
                cursor.itersize = fetch_size
                cursor.execute(statement, parameters)
                for row in cursor:
                    yield JobRecord(*row)


def _escape_like(value: str) -> str:
    return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
