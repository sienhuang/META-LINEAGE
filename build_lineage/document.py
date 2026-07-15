from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from .column_tracer import ColumnTrace
from .postgres import JobRecord


SCHEMA_VERSION = "1.0"
DEFAULT_OUTPUT_ROOT = Path(__file__).resolve().parent / "output"


def build_column_logic_document(
    job: JobRecord,
    trace: ColumnTrace,
    *,
    include_trace: bool = False,
) -> dict[str, Any]:
    traced = trace.to_dict(include_trace=include_trace)
    boundaries = [
        {
            "kind": "physical_source",
            "dataset": source.dataset,
            "field": source.field,
            "reason": "single_job_trace_reached_physical_table",
        }
        for source in trace.value_sources
    ]
    return {
        "schema_version": SCHEMA_VERSION,
        "scope": "single_job",
        "complete": not trace.warnings,
        "job": {
            "job_id": job.job_id,
            "job_name": job.job_name,
            "engine": job.engine,
            "write_mode": job.write_mode,
        },
        "target": {
            "dataset": trace.target_table,
            "field": trace.target_field,
            "ref": traced["target"],
        },
        "value_sources": traced["value_sources"],
        "production_logic": {
            "final_transformations": traced["final_transformations"],
            "branches": traced["branches"],
        },
        "relational_context": traced["relational_context"],
        "boundaries": boundaries,
        "warnings": traced["warnings"],
        **({"trace": traced["trace"]} if include_trace else {}),
    }


def default_output_path(job: JobRecord, trace: ColumnTrace) -> Path:
    return (
        DEFAULT_OUTPUT_ROOT
        / _safe_path_part(job.job_id)
        / _safe_path_part(trace.target_field)
        / "column_logic.json"
    )


def write_column_logic_document(
    document: dict[str, Any],
    output_path: Path,
) -> Path:
    output_path = output_path.expanduser().resolve()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = output_path.with_suffix(f"{output_path.suffix}.tmp")
    temporary.write_text(
        json.dumps(document, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    temporary.replace(output_path)
    return output_path


def _safe_path_part(value: str) -> str:
    cleaned = "".join(
        character if character.isalnum() or character in "._-" else "_"
        for character in value
    )
    return cleaned or "unnamed"

