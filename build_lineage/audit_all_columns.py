from __future__ import annotations

import json
import logging
import re
import sys
import time
from collections import Counter
from collections.abc import Callable, Iterable, Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any, TextIO

from .builder import SingleJobProductionBuilder
from .metadata import TableMetadataClient
from .postgres import JobRecord
from .production_sql import write_production_sql
from .statements import classify_statement, is_select_only_validation, job_identity


DEFAULT_AUDIT_ROOT = Path(__file__).resolve().parent / "audit_runs"
MAX_ERROR_LENGTH = 4000


class _AuditDiagnosticLog(logging.Handler):
    def __init__(self, output: TextIO) -> None:
        super().__init__(level=logging.WARNING)
        self.output = output
        self.event_count = 0
        self.context: dict[str, Any] = {}

    def set_context(
        self,
        job: JobRecord,
        phase: str,
        column: str | None,
    ) -> None:
        business_job_id, statement_index = job_identity(job.job_id)
        self.context = {
            "job_id": job.job_id,
            "job_name": job.job_name,
            "business_job_id": business_job_id,
            "statement_index": statement_index,
            "phase": phase,
            "column": column,
        }

    def emit(self, record: logging.LogRecord) -> None:
        try:
            self._write({
                "level": record.levelname,
                "logger": record.name,
                "message": record.getMessage(),
            })
        except Exception:
            self.handleError(record)

    def exception(self, error: Exception) -> None:
        self._write({
            "level": "ERROR",
            "logger": "build_lineage.audit",
            "error_type": type(error).__name__,
            "message": str(error).strip()[:MAX_ERROR_LENGTH],
        })

    def _write(self, event: dict[str, Any]) -> None:
        self.event_count += 1
        self.output.write(json.dumps({
            "timestamp": datetime.now(UTC).isoformat(),
            **self.context,
            **event,
        }, ensure_ascii=False) + "\n")
        self.output.flush()


@contextmanager
def _capture_sqlglot_logs(
    diagnostic_log: _AuditDiagnosticLog,
) -> Iterator[None]:
    logger = logging.getLogger("sqlglot")
    previous_handlers = list(logger.handlers)
    previous_level = logger.level
    previous_propagate = logger.propagate
    logger.handlers = [diagnostic_log]
    logger.setLevel(logging.WARNING)
    logger.propagate = False
    try:
        yield
    finally:
        logger.handlers = previous_handlers
        logger.setLevel(previous_level)
        logger.propagate = previous_propagate


@dataclass(frozen=True)
class AuditOptions:
    report_dir: Path
    write_sql: bool = False
    max_columns_per_job: int | None = None
    progress_every: int = 100


class ProductionSqlAuditor:
    def __init__(
        self,
        options: AuditOptions,
        metadata_client: TableMetadataClient | None = None,
    ) -> None:
        if options.max_columns_per_job is not None and options.max_columns_per_job < 1:
            raise ValueError("max_columns_per_job must be >= 1")
        if options.progress_every < 1:
            raise ValueError("progress_every must be >= 1")
        self.options = options
        self.metadata_client = metadata_client

    def run(
        self,
        jobs: Iterable[JobRecord],
        *,
        progress: Callable[[dict[str, Any]], None] | None = None,
    ) -> dict[str, Any]:
        report_dir = self.options.report_dir.expanduser().resolve()
        report_dir.mkdir(parents=True, exist_ok=True)
        started_at = datetime.now(UTC)
        started = time.monotonic()
        counters: Counter[str] = Counter()
        failure_groups: dict[str, dict[str, Any]] = {}
        tables: dict[str, dict[str, Any]] = {}
        tasks: dict[str, dict[str, Any]] = {}
        failures_path = report_dir / "failures.jsonl"
        successes_path = report_dir / "successes.jsonl"
        diagnostics_path = report_dir / "diagnostics.jsonl"
        last_progress_columns = 0

        with failures_path.open("w", encoding="utf-8") as failures_file, \
                successes_path.open("w", encoding="utf-8") as successes_file, \
                diagnostics_path.open("w", encoding="utf-8") as diagnostics_file:
            diagnostic_log = _AuditDiagnosticLog(diagnostics_file)
            with _capture_sqlglot_logs(diagnostic_log):
                for job in jobs:
                    counters["jobs_seen"] += 1
                    statement = self._audit_job(
                        job,
                        counters,
                        tables,
                        failure_groups,
                        failures_file,
                        successes_file,
                        diagnostic_log,
                    )
                    _record_task_statement(tasks, job, statement)
                    if progress is not None and (
                        counters["columns_attempted"] - last_progress_columns
                        >= self.options.progress_every
                    ):
                        progress(_progress_snapshot(counters, job))
                        last_progress_columns = counters["columns_attempted"]
            counters["diagnostic_events"] = diagnostic_log.event_count

        finished_at = datetime.now(UTC)
        task_rows = _task_rows(tasks)
        counters["business_tasks"] = len(task_rows)
        counters["multi_statement_tasks"] = sum(
            1 for task in task_rows if task["statement_count"] > 1
        )
        summary = {
            "schema_version": "1.0",
            "started_at": started_at.isoformat(),
            "finished_at": finished_at.isoformat(),
            "duration_seconds": round(time.monotonic() - started, 3),
            "options": {
                "write_sql": self.options.write_sql,
                "max_columns_per_job": self.options.max_columns_per_job,
                "progress_every": self.options.progress_every,
            },
            "counts": {
                key: counters[key]
                for key in (
                    "jobs_seen",
                    "jobs_parsed",
                    "jobs_failed",
                    "business_tasks",
                    "multi_statement_tasks",
                    "empty_overwrites",
                    "statements_skipped",
                    "target_tables",
                    "columns_discovered",
                    "columns_attempted",
                    "columns_succeeded",
                    "columns_failed",
                    "sql_files_written",
                    "diagnostic_events",
                )
            },
            "columns_not_attempted": (
                counters["columns_discovered"] - counters["columns_attempted"]
            ),
            "issues_total": counters["jobs_failed"] + counters["columns_failed"],
            "success_rate": (
                round(
                    counters["columns_succeeded"] / counters["columns_attempted"],
                    6,
                )
                if counters["columns_attempted"]
                else None
            ),
            "report_dir": str(report_dir),
            "files": {
                "failures": str(failures_path),
                "successes": str(successes_path),
                "failure_groups": str(report_dir / "failure_groups.json"),
                "tables": str(report_dir / "tables.json"),
                "tasks": str(report_dir / "tasks.json"),
                "diagnostics": str(diagnostics_path),
            },
        }
        _write_json(report_dir / "summary.json", summary)
        _write_json(
            report_dir / "failure_groups.json",
            sorted(
                failure_groups.values(),
                key=lambda item: (-item["count"], item["category"]),
            ),
        )
        _write_json(
            report_dir / "tables.json",
            [
                {
                    "target_table": table,
                    **{
                        key: value for key, value in data.items()
                        if key != "job_ids"
                    },
                    "job_ids": sorted(data["job_ids"]),
                }
                for table, data in sorted(tables.items())
            ],
        )
        _write_json(report_dir / "tasks.json", task_rows)
        return summary

    def _audit_job(
        self,
        job: JobRecord,
        counters: Counter[str],
        tables: dict[str, dict[str, Any]],
        failure_groups: dict[str, dict[str, Any]],
        failures_file: TextIO,
        successes_file: TextIO,
        diagnostic_log: "_AuditDiagnosticLog",
    ) -> dict[str, Any]:
        business_job_id, statement_index = job_identity(job.job_id)
        builder = SingleJobProductionBuilder(job.engine, self.metadata_client)
        diagnostic_log.set_context(job, "inspect_insert", None)
        try:
            parsed = builder.inspect(job.raw_sql)
        except Exception as error:  # batch boundary: one bad job must not stop the run
            if is_select_only_validation(job, error):
                counters["statements_skipped"] += 1
                return {
                    "business_job_id": business_job_id,
                    "statement_index": statement_index,
                    "statement_role": "select_only",
                    "classification_reason": "stored validation SELECT",
                    "produces_rows": False,
                    "audit_status": "skipped_select_only",
                    "target_table": None,
                    "partitions": {},
                    "source_datasets": [],
                    "columns_discovered": 0,
                    "columns_attempted": 0,
                    "columns_succeeded": 0,
                    "columns_failed": 0,
                }
            diagnostic_log.exception(error)
            counters["jobs_failed"] += 1
            issue = _issue(job, None, None, "parse_job", error)
            _record_failure(issue, failure_groups, failures_file)
            return {
                "business_job_id": business_job_id,
                "statement_index": statement_index,
                "statement_role": "unknown",
                "audit_status": "parse_failed",
                "target_table": None,
                "partitions": {},
                "columns_discovered": 0,
                "columns_attempted": 0,
                "columns_succeeded": 0,
                "columns_failed": 0,
            }

        counters["jobs_parsed"] += 1
        diagnostic_log.set_context(job, "classify_statement", None)
        classification = classify_statement(job, parsed)
        target = parsed.target_table
        table = tables.setdefault(target, {
            "job_ids": set(),
            "jobs": 0,
            "columns_discovered": 0,
            "columns_succeeded": 0,
            "columns_failed": 0,
            "statement_roles": Counter(),
        })
        if not table["job_ids"]:
            counters["target_tables"] += 1
        table["job_ids"].add(job.job_id)
        table["jobs"] += 1
        table["statement_roles"][classification.role] += 1

        statement_summary = {
            **classification.to_dict(),
            "audit_status": "audited",
            "columns_discovered": 0,
            "columns_attempted": 0,
            "columns_succeeded": 0,
            "columns_failed": 0,
        }
        if classification.role == "empty_overwrite":
            counters["empty_overwrites"] += 1
            counters["statements_skipped"] += 1
            statement_summary["audit_status"] = "skipped_empty_overwrite"
            return statement_summary

        columns = list(dict.fromkeys(
            item.name for item in parsed.output_columns if not item.is_partition
        ))
        counters["columns_discovered"] += len(columns)
        table["columns_discovered"] += len(columns)
        statement_summary["columns_discovered"] = len(columns)
        if self.options.max_columns_per_job is not None:
            columns = columns[:self.options.max_columns_per_job]

        for column in columns:
            counters["columns_attempted"] += 1
            statement_summary["columns_attempted"] += 1
            column_started = time.monotonic()
            diagnostic_log.set_context(job, "build_production_sql", column)
            try:
                production = builder.build(job.raw_sql, column).production
            except Exception as error:  # see batch boundary above
                diagnostic_log.exception(error)
                counters["columns_failed"] += 1
                table["columns_failed"] += 1
                statement_summary["columns_failed"] += 1
                issue = _issue(job, target, column, "build_production_sql", error)
                _record_failure(issue, failure_groups, failures_file)
                continue

            sql_path: str | None = None
            if self.options.write_sql:
                output = (
                    self.options.report_dir
                    / "sql"
                    / _safe_part(job.job_id)
                    / _safe_part(column)
                    / "production.sql"
                )
                try:
                    diagnostic_log.set_context(job, "write_sql", column)
                    sql_path = str(write_production_sql(production.sql, output))
                    counters["sql_files_written"] += 1
                except Exception as error:  # filesystem failure is a column failure
                    diagnostic_log.exception(error)
                    counters["columns_failed"] += 1
                    table["columns_failed"] += 1
                    statement_summary["columns_failed"] += 1
                    issue = _issue(job, target, column, "write_sql", error)
                    _record_failure(issue, failure_groups, failures_file)
                    continue

            counters["columns_succeeded"] += 1
            table["columns_succeeded"] += 1
            statement_summary["columns_succeeded"] += 1
            _write_jsonl(successes_file, {
                "job_id": job.job_id,
                "job_name": job.job_name,
                "business_job_id": classification.business_job_id,
                "statement_index": classification.statement_index,
                "statement_role": classification.role,
                "target_table": target,
                "column": column,
                "value_sources": list(production.value_sources),
                "union_branch_count": production.union_branch_count,
                "output_columns": list(production.output_columns),
                "duration_ms": round((time.monotonic() - column_started) * 1000, 3),
                "sql_path": sql_path,
            })
        return statement_summary


def default_audit_report_dir() -> Path:
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return DEFAULT_AUDIT_ROOT / stamp


def _record_task_statement(
    tasks: dict[str, dict[str, Any]],
    job: JobRecord,
    statement: dict[str, Any],
) -> None:
    business_job_id = str(statement["business_job_id"])
    task = tasks.setdefault(business_job_id, {
        "business_job_id": business_job_id,
        "statements": [],
    })
    task["statements"].append({
        "job_id": job.job_id,
        "job_name": job.job_name,
        **{
            key: value for key, value in statement.items()
            if key != "business_job_id"
        },
    })


def _task_rows(tasks: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for business_job_id, task in sorted(tasks.items()):
        statements = sorted(
            task["statements"],
            key=lambda item: (
                item["statement_index"] is None,
                item["statement_index"] if item["statement_index"] is not None else 0,
                item["job_id"],
            ),
        )
        role_counts = Counter(
            statement["statement_role"] for statement in statements
        )
        rows.append({
            "business_job_id": business_job_id,
            "statement_count": len(statements),
            "statement_role_counts": dict(sorted(role_counts.items())),
            "statements": statements,
        })
    return rows


def print_progress(snapshot: dict[str, Any]) -> None:
    print(json.dumps(snapshot, ensure_ascii=False), file=sys.stderr, flush=True)


def _issue(
    job: JobRecord,
    target_table: str | None,
    column: str | None,
    phase: str,
    error: Exception,
) -> dict[str, Any]:
    message = str(error).strip()[:MAX_ERROR_LENGTH]
    category = _categorize_error(message)
    return {
        "job_id": job.job_id,
        "job_name": job.job_name,
        "engine": job.engine,
        "target_table": target_table,
        "column": column,
        "phase": phase,
        "category": category,
        "error_type": type(error).__name__,
        "error": message,
        "raw_sql_length": len(job.raw_sql),
    }


def _record_failure(
    issue: dict[str, Any],
    groups: dict[str, dict[str, Any]],
    output: TextIO,
) -> None:
    _write_jsonl(output, issue)
    key = f"{issue['phase']}:{issue['category']}:{issue['error_type']}"
    group = groups.setdefault(key, {
        "signature": key,
        "phase": issue["phase"],
        "category": issue["category"],
        "error_type": issue["error_type"],
        "count": 0,
        "samples": [],
    })
    group["count"] += 1
    if len(group["samples"]) < 5:
        group["samples"].append({
            "job_id": issue["job_id"],
            "target_table": issue["target_table"],
            "column": issue["column"],
            "error": issue["error"],
        })


def _categorize_error(message: str) -> str:
    lowered = message.lower()
    patterns = (
        ("projection pruning removed every output", "projection_pruning_empty"),
        ("changed value sources", "value_source_mismatch"),
        ("does not output column", "derived_output_missing"),
        ("sql parse failed", "sql_parse_failed"),
        ("expected insert", "not_insert"),
        ("column trace failed", "column_trace_failed"),
        ("union", "union_resolution"),
        ("star", "star_resolution"),
        ("static partition", "static_partition"),
    )
    for text, category in patterns:
        if text in lowered:
            return category
    return "unclassified"


def _progress_snapshot(counters: Counter[str], job: JobRecord) -> dict[str, Any]:
    return {
        "event": "progress",
        "job_id": job.job_id,
        "jobs_seen": counters["jobs_seen"],
        "columns_attempted": counters["columns_attempted"],
        "columns_succeeded": counters["columns_succeeded"],
        "columns_failed": counters["columns_failed"],
    }


def _write_json(path: Path, value: object) -> None:
    temporary = path.with_suffix(f"{path.suffix}.tmp")
    temporary.write_text(
        json.dumps(value, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    temporary.replace(path)


def _write_jsonl(output: TextIO, value: object) -> None:
    output.write(json.dumps(value, ensure_ascii=False) + "\n")
    output.flush()


def _safe_part(value: str) -> str:
    return re.sub(r"[^A-Za-z0-9._-]", "_", value) or "unnamed"
