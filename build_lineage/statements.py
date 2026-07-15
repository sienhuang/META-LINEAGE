from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any

import sqlglot
from sqlglot import exp

from .postgres import JobRecord
from .sql_parser import ParsedInsert, SqlStructureParser


EXACT_JOB_ID = re.compile(r"^job\.(?P<business>.+)_(?P<index>\d+)$")
SNAPSHOT_SUFFIXES = ("_hdfs", "_snapshot", "_backup", "_bak")


@dataclass(frozen=True)
class StatementClassification:
    business_job_id: str
    statement_index: int | None
    role: str
    reason: str
    produces_rows: bool
    target_table: str
    partitions: tuple[tuple[str, str | None], ...]
    source_datasets: tuple[str, ...]

    def to_dict(self) -> dict[str, Any]:
        return {
            "business_job_id": self.business_job_id,
            "statement_index": self.statement_index,
            "statement_role": self.role,
            "classification_reason": self.reason,
            "produces_rows": self.produces_rows,
            "target_table": self.target_table,
            "partitions": {
                name: value for name, value in self.partitions
            },
            "source_datasets": list(self.source_datasets),
        }


def job_identity(job_id: str) -> tuple[str, int | None]:
    match = EXACT_JOB_ID.fullmatch(job_id.strip())
    if match is None:
        return job_id.removeprefix("job."), None
    return match.group("business"), int(match.group("index"))


def classify_statement(
    job: JobRecord,
    parsed: ParsedInsert | None = None,
) -> StatementClassification:
    parsed = parsed or SqlStructureParser(job.engine).parse_insert(job.raw_sql)
    business_job_id, statement_index = job_identity(job.job_id)
    query = sqlglot.parse_one(job.raw_sql, read=job.engine)
    insert_query = query.expression if isinstance(query, exp.Insert) else None

    if (
        parsed.overwrite
        and isinstance(insert_query, exp.Query)
        and _query_is_statically_empty(insert_query)
    ):
        role = "empty_overwrite"
        reason = "top-level query is statically empty"
        produces_rows = False
    elif (
        parsed.target_table.lower().endswith(SNAPSHOT_SUFFIXES)
        and len(parsed.source_datasets) == 1
    ):
        role = "snapshot_copy"
        reason = "single-source write to a snapshot-like target"
        produces_rows = True
    else:
        role = "data_write"
        reason = "normal INSERT data production"
        produces_rows = True

    return StatementClassification(
        business_job_id=business_job_id,
        statement_index=statement_index,
        role=role,
        reason=reason,
        produces_rows=produces_rows,
        target_table=parsed.target_table,
        partitions=tuple(
            (partition.name, partition.value_sql)
            for partition in parsed.partitions
        ),
        source_datasets=tuple(parsed.source_datasets),
    )


def _query_is_statically_empty(query: exp.Query) -> bool:
    if isinstance(query, exp.Select):
        limit = query.args.get("limit")
        if isinstance(limit, exp.Limit):
            value = limit.expression
            if isinstance(value, exp.Literal) and value.is_int and int(value.this) == 0:
                return True
        where = query.args.get("where")
        if isinstance(where, exp.Where):
            return _static_boolean(where.this) is False
    return False


def _static_boolean(expression: exp.Expression) -> bool | None:
    if isinstance(expression, exp.Paren):
        return _static_boolean(expression.this)
    if isinstance(expression, exp.Boolean):
        return bool(expression.this)
    if isinstance(expression, exp.And):
        left = _static_boolean(expression.left)
        right = _static_boolean(expression.right)
        if left is False or right is False:
            return False
        if left is True and right is True:
            return True
        return None
    if isinstance(expression, exp.Or):
        left = _static_boolean(expression.left)
        right = _static_boolean(expression.right)
        if left is True or right is True:
            return True
        if left is False and right is False:
            return False
        return None
    if isinstance(expression, exp.Not):
        value = _static_boolean(expression.this)
        return None if value is None else not value
    if isinstance(expression, (exp.EQ, exp.NEQ, exp.GT, exp.GTE, exp.LT, exp.LTE)):
        left = _literal_value(expression.left)
        right = _literal_value(expression.right)
        if left is None or right is None:
            return None
        if isinstance(expression, exp.EQ):
            return left == right
        if isinstance(expression, exp.NEQ):
            return left != right
        try:
            if isinstance(expression, exp.GT):
                return left > right
            if isinstance(expression, exp.GTE):
                return left >= right
            if isinstance(expression, exp.LT):
                return left < right
            return left <= right
        except TypeError:
            return None
    return None


def _literal_value(expression: exp.Expression) -> str | int | float | None:
    if not isinstance(expression, exp.Literal):
        return None
    if expression.is_string:
        return str(expression.this)
    try:
        text = str(expression.this)
        return float(text) if "." in text else int(text)
    except ValueError:
        return None
