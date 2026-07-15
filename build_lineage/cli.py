from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import psycopg2

from . import __version__
from .audit_all_columns import (
    AuditOptions,
    ProductionSqlAuditor,
    default_audit_report_dir,
    print_progress,
)
from .builder import SingleJobProductionBuilder
from .column_tracer import SingleJobColumnTracer
from .config import PostgresConfig
from .document import (
    build_column_logic_document,
    default_output_path,
    write_column_logic_document,
)
from .metadata import TableMetadataClient
from .postgres import PostgresJobRepository
from .production_sql import (
    default_production_sql_path,
    write_production_sql,
)
from .sql_parser import SqlStructureParser
from .statements import classify_statement, job_identity


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="python -m build_lineage",
        description="Independent column production-lineage builder",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser(
        "status",
        help="show the current implementation stage",
    )
    subparsers.add_parser(
        "db-check",
        help="check PostgreSQL and the configured lineage.job table",
    )
    show_schema = subparsers.add_parser(
        "show-table-schema",
        help="read column positions and details from the HTTP metadata service",
    )
    show_schema.add_argument(
        "--table",
        required=True,
        help="target table in database.table form",
    )
    show_job = subparsers.add_parser(
        "show-job",
        help="read one raw SQL job from PostgreSQL",
    )
    show_job.add_argument(
        "--job-id",
        required=True,
        help="business task id (100021029) or exact stored job id",
    )
    show_job.add_argument(
        "--include-sql",
        action="store_true",
        help="include the complete raw_sql in the JSON output",
    )
    parse_job = subparsers.add_parser(
        "parse-job",
        help="parse the INSERT structure of one PostgreSQL job",
    )
    parse_job.add_argument("--job-id", required=True)
    parse_job.add_argument(
        "--include-expressions",
        action="store_true",
        help="include every output expression in the JSON output",
    )
    trace_column = subparsers.add_parser(
        "trace-column",
        help="trace one output column inside a single SQL job",
    )
    trace_column.add_argument("--job-id", required=True)
    trace_column.add_argument("--column", required=True)
    trace_column.add_argument(
        "--include-trace",
        action="store_true",
        help="include the complete recursive lineage tree",
    )
    build_logic = subparsers.add_parser(
        "build-column-logic",
        help="write a stable column_logic.json for one job column",
    )
    build_logic.add_argument("--job-id", required=True)
    build_logic.add_argument("--column", required=True)
    build_logic.add_argument(
        "--output",
        help="output JSON path; defaults under build_lineage/output",
    )
    build_logic.add_argument(
        "--include-trace",
        action="store_true",
        help="include the complete recursive lineage tree",
    )
    build_sql = subparsers.add_parser(
        "build-production-sql",
        help="write a validated standalone production.sql for one job column",
    )
    build_sql.add_argument("--job-id", required=True)
    build_sql.add_argument("--column", required=True)
    build_sql.add_argument(
        "--output",
        help="output SQL path; defaults beside column_logic.json",
    )
    audit = subparsers.add_parser(
        "audit-production-sql",
        help="build and validate production SQL for every output column",
    )
    audit_source = audit.add_mutually_exclusive_group(required=True)
    audit_source.add_argument(
        "--all-jobs",
        action="store_true",
        help="scan every job in lineage.job",
    )
    audit_source.add_argument(
        "--job-id",
        action="append",
        help="scan one business/exact job id; may be repeated",
    )
    audit.add_argument("--limit", type=int, help="maximum jobs to scan")
    audit.add_argument("--offset", type=int, default=0)
    audit.add_argument("--fetch-size", type=int, default=50)
    audit.add_argument("--max-columns-per-job", type=int)
    audit.add_argument("--progress-every", type=int, default=100)
    audit.add_argument("--report-dir")
    audit.add_argument(
        "--write-sql",
        action="store_true",
        help="also persist every successful production.sql",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    if args.command == "status":
        print(json.dumps({
            "package": "build_lineage",
            "version": __version__,
            "stage": 7,
            "status": "batch_production_sql_audit_ready",
            "postgresql": "run db-check to verify",
            "sql_parser": "batch_audit_ready",
            "legacy_runtime_dependency": False,
        }, ensure_ascii=False, indent=2))
        return 0

    try:
        metadata_client = TableMetadataClient.from_env()
        if args.command == "show-table-schema":
            table = metadata_client.get_table_by_name(args.table)
            _print_json({"ok": True, **table.to_dict()})
            return 0

        repository = PostgresJobRepository(PostgresConfig.from_env())
        if args.command == "db-check":
            _print_json(repository.check_connection())
            return 0
        if args.command == "show-job":
            result = repository.find_jobs(args.job_id)
            output = {
                "query": result.query,
                "match_count": len(result.matches),
                "unique": result.unique,
                "jobs": [
                    _job_description(item, include_sql=args.include_sql)
                    for item in result.matches
                ],
            }
            _print_json(output)
            if not result.found:
                return 2
            if not result.unique:
                return 3
            return 0
        if args.command == "parse-job":
            result = repository.find_jobs(args.job_id)
            if not result.found:
                _print_json({
                    "ok": False,
                    "error": f"job not found: {args.job_id}",
                }, stream=sys.stderr)
                return 2
            if not result.unique:
                _print_json(
                    _ambiguous_job_output(args.job_id, result.matches),
                    stream=sys.stderr,
                )
                return 3
            job = result.matches[0]
            parsed = SqlStructureParser(dialect=job.engine).parse_insert(job.raw_sql)
            output = {
                "job_id": job.job_id,
                "job_name": job.job_name,
                **parsed.to_dict(include_expressions=args.include_expressions),
            }
            _print_json(output)
            return 0
        if args.command == "trace-column":
            result = repository.find_jobs(args.job_id)
            if not result.found:
                _print_json({
                    "ok": False,
                    "error": f"job not found: {args.job_id}",
                }, stream=sys.stderr)
                return 2
            if not result.unique:
                _print_json(
                    _ambiguous_job_output(args.job_id, result.matches),
                    stream=sys.stderr,
                )
                return 3
            job = result.matches[0]
            traced = SingleJobColumnTracer(
                job.engine,
                metadata_client=metadata_client,
            ).trace(
                job.raw_sql,
                args.column,
            )
            _print_json({
                "job_id": job.job_id,
                "job_name": job.job_name,
                **traced.to_dict(include_trace=args.include_trace),
            })
            return 0
        if args.command == "build-column-logic":
            result = repository.find_jobs(args.job_id)
            if not result.found:
                _print_json({
                    "ok": False,
                    "error": f"job not found: {args.job_id}",
                }, stream=sys.stderr)
                return 2
            if not result.unique:
                _print_json(
                    _ambiguous_job_output(args.job_id, result.matches),
                    stream=sys.stderr,
                )
                return 3
            job = result.matches[0]
            traced = SingleJobColumnTracer(
                job.engine,
                metadata_client=metadata_client,
            ).trace(
                job.raw_sql,
                args.column,
            )
            document = build_column_logic_document(
                job,
                traced,
                include_trace=args.include_trace,
            )
            output_path = (
                default_output_path(job, traced)
                if not args.output
                else Path(args.output)
            )
            written = write_column_logic_document(document, output_path)
            _print_json({
                "ok": True,
                "complete": document["complete"],
                "target": document["target"]["ref"],
                "output": str(written),
            })
            return 0
        if args.command == "build-production-sql":
            result = repository.find_jobs(args.job_id)
            if not result.found:
                _print_json({
                    "ok": False,
                    "error": f"job not found: {args.job_id}",
                }, stream=sys.stderr)
                return 2
            if result.unique:
                output = _build_production_for_statement(
                    result.matches[0],
                    args.column,
                    metadata_client,
                    Path(args.output) if args.output else None,
                )
                _print_json({
                    "ok": True,
                    **output,
                })
                return 0

            if args.output:
                raise ValueError(
                    "--output cannot be used when a business job expands to "
                    "multiple INSERT statements"
                )
            statement_results = []
            for job in sorted(result.matches, key=_statement_sort_key):
                parsed = SqlStructureParser(job.engine).parse_insert(job.raw_sql)
                classification = classify_statement(job, parsed)
                base = {
                    "job_id": job.job_id,
                    "statement_index": classification.statement_index,
                    "statement_role": classification.role,
                    "target_table": classification.target_table,
                    "partitions": dict(classification.partitions),
                }
                if classification.role == "empty_overwrite":
                    statement_results.append({
                        **base,
                        "status": "skipped",
                        "reason": "empty_overwrite does not produce rows",
                    })
                    continue
                try:
                    built = _build_production_for_statement(
                        job,
                        args.column,
                        metadata_client,
                        None,
                    )
                except ValueError as error:
                    if "is not an INSERT output column" in str(error):
                        statement_results.append({
                            **base,
                            "status": "skipped",
                            "reason": "target field is not produced by this INSERT",
                        })
                    else:
                        statement_results.append({
                            **base,
                            "status": "failed",
                            "error_type": type(error).__name__,
                            "error": str(error).strip(),
                        })
                    continue
                statement_results.append({
                    **base,
                    "status": "generated",
                    **built,
                })

            generated_count = sum(
                item["status"] == "generated" for item in statement_results
            )
            failed_count = sum(
                item["status"] == "failed" for item in statement_results
            )
            skipped_count = sum(
                item["status"] == "skipped" for item in statement_results
            )
            output = {
                "ok": generated_count > 0 and failed_count == 0,
                "business_job_id": args.job_id,
                "column": args.column,
                "statement_count": len(statement_results),
                "generated_count": generated_count,
                "skipped_count": skipped_count,
                "failed_count": failed_count,
                "statements": statement_results,
            }
            _print_json(
                output,
                stream=sys.stderr if failed_count or not generated_count else None,
            )
            return 0 if output["ok"] else 1
        if args.command == "audit-production-sql":
            if args.all_jobs:
                jobs = repository.iter_jobs(
                    limit=args.limit,
                    offset=args.offset,
                    fetch_size=args.fetch_size,
                )
            else:
                selected_by_id = {}
                for job_ref in args.job_id:
                    result = repository.find_jobs(job_ref)
                    if not result.found:
                        raise ValueError(f"job not found: {job_ref}")
                    for item in result.matches:
                        selected_by_id.setdefault(item.job_id, item)
                selected = sorted(
                    selected_by_id.values(),
                    key=_statement_sort_key,
                )
                jobs = iter(selected[args.offset:][:args.limit]) if args.limit else iter(
                    selected[args.offset:]
                )
            report_dir = (
                Path(args.report_dir)
                if args.report_dir
                else default_audit_report_dir()
            )
            auditor = ProductionSqlAuditor(
                AuditOptions(
                    report_dir=report_dir,
                    write_sql=args.write_sql,
                    max_columns_per_job=args.max_columns_per_job,
                    progress_every=args.progress_every,
                ),
                metadata_client=metadata_client,
            )
            summary = auditor.run(jobs, progress=print_progress)
            _print_json(summary)
            return 0
    except (ValueError, psycopg2.Error) as error:
        _print_json({
            "ok": False,
            "error_type": type(error).__name__,
            "error": str(error).strip(),
        }, stream=sys.stderr)
        return 1
    return 1


def _print_json(value: object, *, stream=None) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2), file=stream)


def _job_description(job, *, include_sql: bool = False) -> dict[str, object]:
    value = job.to_dict(include_sql=include_sql)
    try:
        parsed = SqlStructureParser(job.engine).parse_insert(job.raw_sql)
        value.update(classify_statement(job, parsed).to_dict())
    except ValueError as error:
        value.update({
            "statement_role": "unknown",
            "classification_error": str(error),
        })
    return value


def _ambiguous_job_output(job_ref: str, matches) -> dict[str, object]:
    return {
        "ok": False,
        "error": "job reference contains multiple INSERT statements; use an exact job_id",
        "job_ref": job_ref,
        "candidate_jobs": [
            _job_description(job, include_sql=False)
            for job in sorted(matches, key=_statement_sort_key)
        ],
    }


def _statement_sort_key(job) -> tuple[str, bool, int, str]:
    business_job_id, statement_index = job_identity(job.job_id)
    return (
        business_job_id,
        statement_index is None,
        statement_index if statement_index is not None else 0,
        job.job_id,
    )


def _build_production_for_statement(
    job,
    column: str,
    metadata_client: TableMetadataClient,
    output_path: Path | None,
) -> dict[str, object]:
    result = SingleJobProductionBuilder(
        job.engine,
        metadata_client,
    ).build(job.raw_sql, column)
    production = result.production
    written = write_production_sql(
        production.sql,
        output_path or default_production_sql_path(job, column),
    )
    return {
        **production.summary(),
        "output": str(written),
    }


if __name__ == "__main__":
    raise SystemExit(main())
